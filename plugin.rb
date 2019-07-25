# name: GroupDomain
# about: add to Group if email is in a given Domain
# version: 0.1
# authors: pfaffman
# url: https://github.com/pfaffman/discourse-group-domain


register_asset "stylesheets/common/group-domain.scss"


enabled_site_setting :group_domain_enabled

PLUGIN_NAME ||= "GroupDomain".freeze

after_initialize do
  load File.expand_path('app/jobs/group_domain_daily.rb', __dir__)

  # see lib/plugin/instance.rb for the methods available in this context


  module ::GroupDomain
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace GroupDomain
    end

    def self.process_whitelist_for_all_users
      user_ids = []
      if SiteSetting.group_domain_strict
        # process all users
        user_ids = User.human_users.pluck(:id)
      else
        # get just the users likely matching with matching whitelist
        SiteSetting.group_domain_whitelist.split("|").each do |domain|
          user_ids = user_ids + UserEmail.where("email like '%#{domain}'").pluck(:user_id)
        end
      end
      user_ids.each do |uid|
        user = User.find(uid)
        GroupDomain.add_to_group_if_in_whitelisted_domain(user)
      end
    end

    def self.add_to_group_if_in_whitelisted_domain(user)
      group = Group.find_by(name: SiteSetting.group_domain_group)
      exit unless group
      whitelisted = false
      SiteSetting.group_domain_whitelist.split("|").each do |domain|
        user.emails.each do |e|
          whitelisted |= e.ends_with?(domain)
        end
      end
      if whitelisted
        gu = GroupUser.find_by(group_id: group.id, user_id: user.id)
        GroupUser.create(group_id: group.id, user_id: user.id) unless gu
      end
      if !whitelisted && SiteSetting.group_domain_strict
        gu = GroupUser.find_by(user_id: user.id, group_id: group.id)
        gu.destroy! if gu
      end
    end
  end

  require_dependency "application_controller"
  class GroupDomain::ActionsController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    before_action :ensure_logged_in

    def list
      render json: success_json
    end
  end

  GroupDomain::Engine.routes.draw do
    get "/list" => "actions#list"
  end

  Discourse::Application.routes.append do
    mount ::GroupDomain::Engine, at: "/group-domain"
  end

  DiscourseEvent.on(:user_created) do |user|
    GroupDomain.add_to_group_if_in_whitelisted_domain(user)
  end

  self.add_model_callback(UserEmail, :after_commit, on: :update) do
    user = User.find(self.user_id)
    GroupDomain.add_to_group_if_in_whitelisted_domain(user)
  end

end
