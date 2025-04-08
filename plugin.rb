# frozen_string_literal: true

# name: discourse-open-graph
# about: Overrides the default Open Graph meta tags
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
  overrides = DiscourseOpenGraph::OpenGraphOverrides.new
  register_modifier(:meta_data_content) do |content, property, opts|
    url = opts[:url]
    override = overrides.find_by_url(url)
    if override
      content = override[property] if override[property] # it can be either :title or :description 
    end
    content
  end
end
