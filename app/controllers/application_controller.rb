require_relative '../facades/github_facade'

class ApplicationController < ActionController::Base

  before_action :get_github_data

  def get_github_data
    @repo = GitHubFacade.generate_repo
    
  end
end
