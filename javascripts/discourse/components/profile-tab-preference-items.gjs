import Component from "@glimmer/component";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import dIcon from "discourse-common/helpers/d-icon";

export default class ProfileTabPreferenceItems extends Component {
  @service currentUser;

  <template>
    {{#each settings.profile_menu_preference_items as |item|}}
      <li class="custom-preference-item">
        <a
          title={{item.label}}
          href="/u/{{this.currentUser.username_lower}}/preferences/{{item.page}}/#{{item.setting}}"
        >
          {{#if item.icon}}
            {{dIcon item.icon}}
          {{/if}}
          <span class="item-label">
            {{item.label}}
          </span>
        </a>
      </li>
    {{/each}}
  </template>
}
