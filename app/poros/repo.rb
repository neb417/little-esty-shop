class Repo
  attr_reader :name,
              :team_members

  def initialize(name, team_members)
    @name = name
    @team_members = team_members
  end
end