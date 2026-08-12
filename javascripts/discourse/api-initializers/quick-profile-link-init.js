import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.8.0", (api) => {
  api.onPageChange((url, title) => {
    const settings = document.querySelectorAll(
      "body.user-preferences-page #user-content [data-setting-name]"
    );
  
    settings.forEach((setting) => {
      const settingName = setting.getAttribute("data-setting-name");
  
      if (!settingName) {
        return;
      }
  
      const existingElement = document.getElementById(settingName);
  
      if (existingElement && existingElement !== setting) {
        return;
      }
  
      setting.id = settingName;
    });
  });
});
