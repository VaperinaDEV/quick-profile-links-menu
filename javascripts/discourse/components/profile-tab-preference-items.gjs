import Component from "@glimmer/component";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import dIcon from "discourse-common/helpers/d-icon";
import { i18n } from "discourse-i18n";

export default class ProfileTabPreferenceItems extends Component {
  @service currentUser;

  get translatedItems() {
    return settings.profile_menu_preference_items.map((item) => {
      let translatedLabel = item.label
        ? item.label
        : i18n(`user.preferences_nav.${item.page}`, {
            defaultValue: item.page,
          });

      return {
        ...item,
        translatedLabel,
      };
    });
  }

  <template>
    {{#each this.translatedItems as |item|}}
      <li class="custom-preference-item">
        <a
          title={{item.translatedLabel}}
          href="/u/{{this.currentUser.username_lower}}/preferences/{{item.page}}/#{{item.setting}}"
        >
          {{#if item.icon}}
            {{dIcon item.icon}}
          {{/if}}
          <span class="item-label">
            {{item.translatedLabel}}
          </span>
        </a>
      </li>
    {{/each}}
  </template>
}
