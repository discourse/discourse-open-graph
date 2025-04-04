# frozen_string_literal: true

# name: discourse-open-graph
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :discourse_open_graph_enabled

module ::DiscourseOpenGraph
  PLUGIN_NAME = "discourse-open-graph"
end

require_relative "lib/discourse_open_graph/engine"

after_initialize do
  # Code which should run after Rails has finished booting
end
