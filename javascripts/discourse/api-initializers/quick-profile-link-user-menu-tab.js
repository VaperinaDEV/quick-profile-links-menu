import { apiInitializer } from "discourse/lib/api";
import I18n from "discourse-i18n";
import ProfileLinksUserMenuTab from "../components/profile-links-user-menu-tab";

export default apiInitializer("1.8.0", (api) => {
  
  const userMenuTabSetting = settings.enabled_user_menu_tab;
  
  if (!userMenuTabSetting) {
    return;
  } 
  
  api.registerUserMenuTab((UserMenuTab) => {
    return class extends UserMenuTab {
      id = "quick-profile-links";
      panelComponent = ProfileLinksUserMenuTab;
      icon = settings.user_menu_tab_icon;

      get title() {
        return I18n.t(themePrefix("quick_profile_link.user_menu_tab_title"));
      }
    };
  });
});
