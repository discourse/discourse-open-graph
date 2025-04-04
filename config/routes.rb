# frozen_string_literal: true

DiscourseOpenGraph::Engine.routes.draw do
  get "/examples" => "examples#index"
  # define routes here
end

Discourse::Application.routes.draw { mount ::DiscourseOpenGraph::Engine, at: "discourse-open-graph" }
