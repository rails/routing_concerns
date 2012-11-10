# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'test/unit'

require 'abstract_controller'
require 'action_controller'
require 'action_dispatch'

require 'routing_concerns'

class CommentsController < ActionController::Base
  def index
    head :ok
  end
end

class FlagsController < ActionController::Base
  def index
    head :ok
  end
end

class RoutingConcernsTest < ActionDispatch::IntegrationTest
  Routes = ActionDispatch::Routing::RouteSet.new.tap do |app|
    app.draw do
      concern :commentable do
        resources :comments
      end

      concern :flaggable do |options|
        resources :flags, options
      end

      resources :posts, concerns: :commentable do
        concerns :flaggable, only: :index
      end

      resource  :post, concerns: :commentable
      resources :comments
    end
  end

  include Routes.url_helpers
  def app; Routes end

  test "accessing concern from resources" do
    get "/posts/1/comments"
    assert_equal "200", @response.code
  end

  test "accessing concern from resource" do
    get "/post/comments"
    assert_equal "200", @response.code
  end

  test "accessing another concern from resources" do
    get "/posts/1/flags"
    assert_equal "200", @response.code
  end

  test "passing options to concern" do
    post "/posts/1/flags"
    assert_equal "404", @response.code
  end
end
