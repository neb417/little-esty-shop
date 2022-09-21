require 'httparty'

class GitHubService

  def self.get_uri(uri)
    response = HTTParty.get(uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.repo
    get_uri('https://api.github.com/repos/neb417/little-esty-shop')
  end

  def self.contributors
    get_uri('https://api.github.com/repos/neb417/little-esty-shop/contributors')
  end

  def self.get_pulls
    get_uri('https://api.github.com/repos/neb417/little-esty-shop/pulls?state=closed')
  end

end
