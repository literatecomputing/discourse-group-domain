import { withPluginApi } from "discourse/lib/plugin-api";

function initializeGroupDomain(api) {
  
  // see app/assets/javascripts/discourse/lib/plugin-api
  // for the functions available via the api object
  
}

export default {
  name: "group-domain",

  initialize() {
    withPluginApi("0.8.24", initializeGroupDomain);
  }
};
