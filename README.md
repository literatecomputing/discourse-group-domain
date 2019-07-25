# GroupDomain

GroupDomain is a plugin for adding users to a group if their email address matches a white list of domains.

## Installation

Follow [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157)
how-to from the official Discourse Meta, using `git clone https://github.com/literatecomputing/discourse-group-domain.git`
as the plugin command.

## Usage

In site settings, you must set `group_domain_whitelist` to a set of email domains that should be added to the group and `group_domain_group` to the name of the group that users should be added to.

If `group_domain_strict` is set the plugin will remove users from the group if their email address changes to a non-white-listed address  (if unset, if you change your address from a whitelisted domainn to another one, you will stay in the group).

`group_domain_update_frequency` is how often a process will run that will update all users (mostly userful if you change the set of whitelisted domains and want to update users' group membership). If `group_domain_strict` is unset, it will process only users whose address matches one of the whitelisted domains and add those users to the group. If `group_domain_strict`  is set, the plugin will process all users and add or remove them to the group. Rather than waiting for the event to be run, you can trigger GroupDomainUpdater::UpdateGroupDomain in Sidekiq.


## Feedback

If you have issues or suggestions for the plugin, please bring them up on
[Discourse Meta](https://meta.discourse.org).

## TODO

disallow activation without domains and group set up

tests
