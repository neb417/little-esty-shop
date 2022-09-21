class Repo
  attr_reader :name,
              :contributors

  def initialize(name, contributors)
    @name = name
    @contributors = contributors
  end
end