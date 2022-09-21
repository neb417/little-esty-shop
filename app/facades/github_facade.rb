require_relative '../services/github_service'
require_relative '../poros/repo'

class GitHubFacade
  
  def self.generate_repo
    name = GitHubService.repo[:name]
    contributors = GitHubService.contributors.find_all.with_index{|user, i| [0,1,3,4].include?(i) }
    team_members = contributors.map{|contributor| {login: contributor[:login], commits: contributor[:contributions]}}
    Repo.new(name, team_members)
  end
end