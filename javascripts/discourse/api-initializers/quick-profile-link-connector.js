import { apiInitializer } from "discourse/lib/api";
import QuickProfileLink from "../components/quick-profile-link";

export default apiInitializer("1.14.0", (api) => {
  api.renderInOutlet("user-profile-controls", QuickProfileLink);
});
