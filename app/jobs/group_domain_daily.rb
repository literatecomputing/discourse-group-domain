module GroupDomainUpdater
  class UpdateGroupDomain < ::Jobs::Scheduled
    every SiteSetting.group_domain_update_frequency.hours

    def execute(args)
      if SiteSetting.group_domain_enabled
        GroupDomain.process_whitelist_for_all_users
      end
    end

  end
end
