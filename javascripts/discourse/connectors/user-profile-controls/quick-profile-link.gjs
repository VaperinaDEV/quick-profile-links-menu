import Component from "@glimmer/component";
import { service } from "@ember/service";
import { action } from "@ember/object";
import { on } from "@ember/modifier";
import DMenu from "float-kit/components/d-menu";
import DropdownMenu from "discourse/components/dropdown-menu";
import DButton from "discourse/components/d-button";
import I18n from "discourse-i18n";

export default class QuickProfileLink extends Component {
  @service currentUser;

  get dMenuLabel() {
    return I18n.t(themePrefix("quick_profile_link.button_label"));
  }

  @action
  closeMenu() {
    this.dMenu.close();
  }

  @action
  onRegisterApi(api) {
    this.dMenu = api;
  }

  <template>
    {{#if this.currentUser}}
      <li>
        <DMenu
          @arrow={{false}}
          @identifier="quick-profile-link"
          @interactive={{true}}
          @triggers="click"
          id="quick-profile-link"
          @icon="pencil"
          @label={{this.dMenuLabel}}
          @modalForMobile={{true}}
          @onRegisterApi={{this.onRegisterApi}}
        >
          <:content>
            <DropdownMenu as |dropdown|>
              {{#each settings.profile_links as |link|}}
                <dropdown.item>
                  <DButton
                    @translatedLabel={{link.label}}
                    @icon={{link.icon}}
                    class="btn-icon-text btn-transparent"
                    @href="/u/{{this.currentUser.username_lower}}/preferences/{{link.page}}/#{{link.setting}}"
                    {{on "click" this.closeMenu}}
                  />
                </dropdown.item>
              {{/each}}
            </DropdownMenu>
          </:content>
        </DMenu>
      </li>
    {{/if}}
  </template>
}
