import { apiInitializer } from "discourse/lib/api";
import I18n from "discourse-i18n";
import CustomProfileTabContent from "../components/custom-profile-tab-content";

export default apiInitializer("1.8.0", (api) => {
  
  const userMenuTabSetting = settings.enabled_user_menu_tab;
  
  if (!userMenuTabSetting) {
    return;
  } 
  
  api.registerUserMenuTab((UserMenuTab) => {
    return class extends UserMenuTab {
      id = "quick-access-profile";
      panelComponent = CustomProfileTabContent;
      icon = settings.user_menu_tab_icon;
      linkWhenActive = "/my/summary";

      get title() {
        return I18n.t(themePrefix("quick_profile_link.user_menu_tab_title"));
      }
    };
  });
});
