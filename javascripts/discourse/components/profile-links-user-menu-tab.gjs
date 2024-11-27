import Component from "@glimmer/component";
import { service } from "@ember/service";
import dIcon from "discourse-common/helpers/d-icon";

export default class ProfileLinksUserMenuTab extends Component {
  @service currentUser;

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
  </template>
}
