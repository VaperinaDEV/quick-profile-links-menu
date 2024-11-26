import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.8.0", (api) => {
  api.onPageChange((url, title) => {
    const dataSettingNames = document.querySelectorAll("body.user-preferences-page #user-content [data-setting-name]");
    
    dataSettingNames.forEach(setting => {
      const settingName = setting.getAttribute("data-setting-name");
      setting.id = settingName;
    });
  });
});
