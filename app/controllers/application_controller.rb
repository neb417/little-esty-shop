require_relative '../facades/github_facade'

class ApplicationController < ActionController::Base

  # before_action :get_github_data

  # for use with code above. put in app/views/layouts/application.html.erb in th body toward the bottom
  # <section id="footer">
  # <p>GitHub Repo Name: <%= @repo.name %><br>
  # Github Contributors:
  #   <ul id="contributors">
  #     <% @repo.team_members.each do |user| %>
  #       <li><%= user[:login] %>, commits: <%= user[:commits] %></li>
  #     <% end %>
  #   </ul>
  #   <br>Number of Merged PRs: <%= @repo.pr %>
  # </p>

  # def get_github_data
  #   @repo = GitHubFacade.generate_repo
  # end
end
