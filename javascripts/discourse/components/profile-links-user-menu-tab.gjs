import Component from "@glimmer/component";
import { service } from "@ember/service";
import { action } from "@ember/object";
import DiscourseURL from "discourse/lib/url";
import DButton from "discourse/components/d-button";
import dIcon from "discourse-common/helpers/d-icon";

export default class ProfileLinksUserMenuTab extends Component {
  @service currentUser;

  get showAllTitle() {
    return I18n.t(themePrefix("quick_profile_link.user_menu_show_all_settings"));
  }

  @action
  showAll() {
    DiscourseURL.routeTo("/my/preferences/account");
  }

  <template>
    <ul class="user-menu-profile-links-tab">
      {{#each settings.profile_links as |link|}}
        <li>
          <a
            title={{link.label}}
            href="/u/{{this.currentUser.username_lower}}/preferences/{{link.page}}/#{{link.setting}}"
          >
            {{dIcon link.icon}}
            <span class="item-label">
              {{link.label}}
            </span>
          </a>
        </li>
      {{/each}}
    </ul>
    <div class="panel-body-bottom">
      <DButton
        class="show-all"
        @action={{this.showAll}}
        @translatedAriaLabel={{this.showAllTitle}}
        @translatedTitle={{this.showAllTitle}}
      >
        {{dIcon "chevron-down" aria-label=this.showAllTitle}}
      </DButton>
    </div>
  </template>
}
