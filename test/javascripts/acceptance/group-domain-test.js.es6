import { acceptance } from "helpers/qunit-helpers";

acceptance("GroupDomain", { loggedIn: true });

test("GroupDomain works", async assert => {
  await visit("/admin/plugins/group-domain");

  assert.ok(false, "it shows the GroupDomain button");
});
