import Component from "@glimmer/component";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import dIcon from "discourse-common/helpers/d-icon";

export default class ProfileTabExtraItems extends Component {
  @service currentUser;

  <template>
    {{#each settings.profile_menu_extra_items as |item|}}
      <li class="custom-extra-item">
        <a
          title={{item.label}}
          href={{item.url}}
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
