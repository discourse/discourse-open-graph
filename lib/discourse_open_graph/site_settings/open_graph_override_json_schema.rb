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
              title: I18n.t("json_schema.url.title"),
              description: I18n.t("json_schema.url.description"),
            },
            title: {
              type: "string",
              title: I18n.t("json_schema.title.title"),
              description: I18n.t("json_schema.title.description"),
            },
            description: {
              type: "string",
              title: I18n.t("json_schema.description.title"),
              description: I18n.t("json_schema.description.description"),
            },
          },
        },
      }
    end
  end
end
