# frozen_string_literal: true

module DiscourseOpenGraph
  class OpenGraphOverrides
    def overrides
      begin
        JSON.parse(SiteSetting.open_graph_overrides).map { |o| o.with_indifferent_access } || []
      rescue JSON::ParserError
        []
      end
    end

    def find_by_url(url)
      overrides.find do |override|
        if override[:url].start_with?("/") && override[:url].end_with?("/")
          regex = Regexp.new(override[:url][1..-2])
          url.match?(regex)
        else
          url.include?(override[:url])
        end
      end
    end
  end
end
