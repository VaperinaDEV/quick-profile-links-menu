import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { LinkTo } from "@ember/routing";
import routeAction from "discourse/helpers/route-action";
import DButton from "discourse/components/d-button";
import DoNotDisturbModal from "discourse/components/modal/do-not-disturb";
import UserStatusModal from "discourse/components/modal/user-status";
import formatAge from "discourse/helpers/format-age";
import dIcon from "discourse-common/helpers/d-icon";
import emoji from "discourse/helpers/emoji";
import concatClass from "discourse/helpers/concat-class";
import { ajax } from "discourse/lib/ajax";
import DoNotDisturb from "discourse/lib/do-not-disturb";
import { userPath } from "discourse/lib/url";
import { i18n } from "discourse-i18n";
import ProfileTabPreferenceItems from "./profile-tab-preference-items";
import ProfileTabExtraItems from "./profile-tab-extra-items";

export default class ProfileTabContent extends Component {
  @service currentUser;
  @service siteSettings;
  @service userStatus;
  @service modal;

  saving = false;

  get showToggleAnonymousButton() {
    return (
      this.currentUser.can_post_anonymously || this.currentUser.is_anonymous
    );
  }

  get isInDoNotDisturb() {
    return !!this.#doNotDisturbUntilDate;
  }

  get doNotDisturbDateTime() {
    return this.#doNotDisturbUntilDate.getTime();
  }

  get showDoNotDisturbEndDate() {
    return !DoNotDisturb.isEternal(
      this.currentUser.get("do_not_disturb_until")
    );
  }

  get #doNotDisturbUntilDate() {
    if (!this.currentUser.get("do_not_disturb_until")) {
      return;
    }
    const date = new Date(this.currentUser.get("do_not_disturb_until"));
    if (date < new Date()) {
      return;
    }
    return date;
  }

  get isPresenceHidden() {
    return this.currentUser.get("user_option.hide_presence");
  }

  @action
  doNotDisturbClick() {
    if (this.saving) {
      return;
    }
    this.saving = true;
    if (this.currentUser.do_not_disturb_until) {
      return this.currentUser.leaveDoNotDisturb().finally(() => {
        this.saving = false;
      });
    } else {
      this.saving = false;
      this.args.closeUserMenu();
      this.modal.show(DoNotDisturbModal);
    }
  }

  @action
  togglePresence() {
    this.currentUser.set("user_option.hide_presence", !this.isPresenceHidden);
    this.currentUser.save(["hide_presence"]);
  }

  @action
  setUserStatusClick() {
    this.args.closeUserMenu();

    this.modal.show(UserStatusModal, {
      model: {
        status: this.currentUser.status,
        pauseNotifications: this.currentUser.isInDoNotDisturb(),
        saveAction: (status, pauseNotifications) =>
          this.userStatus.set(status, pauseNotifications),
        deleteAction: () => this.userStatus.clear(),
      },
    });
  }

  @action
  async toggleAnonymous() {
    await ajax(userPath("toggle-anon"), { type: "POST" });
    window.location.reload();
  }

  <template>
    <ul class="custom-profile-tab-quick-links">
      {{#if this.siteSettings.enable_user_status}}
        <li class="set-user-status">
          <DButton
            @action={{this.setUserStatusClick}}
            class="btn-flat profile-tab-btn"
          >
            {{#if this.currentUser.status}}
              {{emoji this.currentUser.status.emoji}}
              <span class="item-label">
                {{this.currentUser.status.description}}
                {{#if this.currentUser.status.ends_at}}
                  {{formatAge this.currentUser.status.ends_at}}
                {{/if}}
              </span>
            {{else}}
              {{dIcon "circle-plus"}}
              <span class="item-label">
                {{i18n "user_status.set_custom_status"}}
              </span>
            {{/if}}
          </DButton>
        </li>
      {{/if}}
    
      <li
        class={{concatClass
          "presence-toggle"
          (unless this.isPresenceHidden "enabled")
        }}
        title={{i18n "presence_toggle.title"}}
      >
        <DButton @action={{this.togglePresence}} class="btn-flat profile-tab-btn">
          {{dIcon (if this.isPresenceHidden "toggle-off" "toggle-on")}}
          <span class="item-label">
            {{#if this.isPresenceHidden}}
              {{i18n "presence_toggle.offline"}}
            {{else}}
              {{i18n "presence_toggle.online"}}
            {{/if}}
          </span>
        </DButton>
      </li>
    
      <li
        class={{concatClass "do-not-disturb" (if this.isInDoNotDisturb "enabled")}}
      >
        <DButton
          @action={{this.doNotDisturbClick}}
          class="btn-flat profile-tab-btn"
        >
          {{dIcon (if this.isInDoNotDisturb "toggle-on" "toggle-off")}}
          <span class="item-label">
            {{#if this.isInDoNotDisturb}}
              <span>{{i18n "pause_notifications.label"}}</span>
              {{#if this.showDoNotDisturbEndDate}}
                {{formatAge this.doNotDisturbDateTime}}
              {{/if}}
            {{else}}
              {{i18n "pause_notifications.label"}}
            {{/if}}
          </span>
        </DButton>
      </li>
    
      <hr />
    
      <li class="summary">
        <LinkTo @route="user.summary" @model={{this.currentUser}}>
          {{dIcon "user"}}
          <span class="item-label">
            {{i18n "user.summary.title"}}
          </span>
        </LinkTo>
      </li>
    
      <li class="activity">
        <LinkTo @route="userActivity" @model={{this.currentUser}}>
          {{dIcon "bars-staggered"}}
          <span class="item-label">
            {{i18n "user.activity_stream"}}
          </span>
        </LinkTo>
      </li>
    
      {{#if this.currentUser.can_invite_to_forum}}
        <li class="invites">
          <LinkTo @route="userInvited" @model={{this.currentUser}}>
            {{dIcon "user-plus"}}
            <span class="item-label">
              {{i18n "user.invited.title"}}
            </span>
          </LinkTo>
        </li>
      {{/if}}
    
      <li class="drafts">
        <LinkTo @route="userActivity.drafts" @model={{this.currentUser}}>
          {{dIcon "user_menu.drafts"}}
          <span class="item-label">
            {{#if this.currentUser.draft_count}}
              {{i18n "drafts.label_with_count" count=this.currentUser.draft_count}}
            {{else}}
              {{i18n "drafts.label"}}
            {{/if}}
          </span>
        </LinkTo>
      </li>
    
      <li class="preferences">
        <LinkTo @route="preferences" @model={{this.currentUser}}>
          {{dIcon "gear"}}
          <span class="item-label">
            {{i18n "user.preferences.title"}}
          </span>
        </LinkTo>
      </li>

      <ProfileTabPreferenceItems />
    
      {{#if this.showToggleAnonymousButton}}
        <li
          class={{if
            this.currentUser.is_anonymous
            "disable-anonymous"
            "enable-anonymous"
          }}
        >
          <DButton
            @action={{this.toggleAnonymous}}
            class="btn-flat profile-tab-btn"
          >
            {{#if this.currentUser.is_anonymous}}
              {{dIcon "ban"}}
              <span class="item-label">
                {{i18n "switch_from_anon"}}
              </span>
            {{else}}
              {{dIcon "user-secret"}}
              <span class="item-label">
                {{i18n "switch_to_anon"}}
              </span>
            {{/if}}
          </DButton>
        </li>
      {{/if}}

      <ProfileTabExtraItems />

      <hr />

      <li class="logout">
        <DButton @action={{routeAction "logout"}} class="btn-flat profile-tab-btn">
          {{dIcon "right-from-bracket"}}
          <span class="item-label">
            {{i18n "user.log_out"}}
          </span>
        </DButton>
      </li>
    </ul>
  </template>
}
