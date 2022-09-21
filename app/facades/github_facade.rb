require_relative '../services/github_service'
require_relative '../poros/repo'

class GitHubFacade
  
  def self.generate_repo
    name = GitHubService.repo[:name]
    Repo.new(name)
  end
end