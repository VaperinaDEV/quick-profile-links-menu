import Component from "@glimmer/component";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import dIcon from "discourse-common/helpers/d-icon";

export default class CustomProfileTabExtraQuickLinks extends Component {
  @service currentUser;

  <template>
    {{#each settings.profile_menu_extra_links as |link|}}
      <li class="custom-extra-item">
        <a
          title={{link.label}}
          href={{link.url}}
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
