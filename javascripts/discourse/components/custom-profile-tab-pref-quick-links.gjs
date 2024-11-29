import Component from "@glimmer/component";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import dIcon from "discourse-common/helpers/d-icon";

export default class CustomProfileTabPrefQuickLinks extends Component {
  @service currentUser;

  <template>
    {{#each settings.profile_menu_preferences_links as |link|}}
      <li class="custom-preference-item">
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
  </template>
}
