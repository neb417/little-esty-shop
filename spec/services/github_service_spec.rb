require 'rails_helper'
require './app/services/github_service'
require './app/poros/repo'
require './app/facades/github_facade'

RSpec.describe GitHubService do
  # it 'test repo name' do
  #   stub_request(:get, 'https://api.github.com/repos/neb417/little-esty-shop').
  #   with(body: {name: 'little-esty-shop'})

  #   expect(GitHubService.repo[:name]).to eq('little-esty-shop')
  # end
end