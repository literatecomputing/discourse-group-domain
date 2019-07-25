require 'rails_helper'

# these do'nt work, but I don't understand why

describe User do

  before do
    Jobs.run_immediately!
    SiteSetting.group_domain_enabled = true
    SiteSetting.group_domain_whitelist = ['gmail.com']
    #SiteSetting.group_domain_group = group.name
  end

  let(:uncool_user) { Fabricate(:user) }
  let(:cool_user) { Fabricate(:user, email: 'cool@gmail.com') }

  # describe 'when a user is created' do
  #   it 'cool user should be in the cool group' do
  #     expect :cool_user.groups.where(id: :group.id).count.to eq(1)
  #   end

  #   it 'uncool user should not be in the cool group' do
  #     expect :uncool_user.groups.where(id: :group.id).count.to eq(0)
  #   end

  # end

end
