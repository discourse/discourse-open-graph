# frozen_string_literal: true

module DiscourseOpenGraph::SiteSettings
  class OpenGraphOverrideJsonSchema
    def self.schema
      @schema ||= {
        type: "array",
        uniqueItems: true,
        format: "tabs-top",
        items: {
          headerTemplate: "{{ self.url }}",
          type: "object",
          format: "grid-strict",
          properties: {
            url: {
              type: "string",
              title: "URL",
              description:
                "The URL pattern to match against. This can be a partial URL or a regex pattern. For example: `/c/announcements` or `/c/announcements/.*`",
            },
            title: {
              type: "string",
              title: "Title",
              description: "The title to use for the Open Graph meta tag.",
            },
            description: {
              type: "string",
              title: "Description",
              description: "The description to use for the Open Graph meta tag.",
            },
          },
        },
      }
    end
  end
end
