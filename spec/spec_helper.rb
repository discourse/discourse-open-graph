# frozen_string_literal: true

class SiteSettingHelper
  def self.add_json(*jsons)
    jsons.each do |json|
      site_setting = JSON.parse SiteSetting.open_graph_overrides
      site_setting << json
      SiteSetting.open_graph_overrides = site_setting.to_json
    end
  end

  def self.load_testing_overrides
    add_json(
      {
        "url" => "/tag/news",
        "title" => "This is what is going on", # normally it would say Topics tagged news
        "description" => "This is the news", # normally it would say Topics tagged news
      },
      { # this is to test regex compatibility
        # any url that has "official" in the name
        "url" => "/.*official*./",
        "title" => "This is official",
        "description" => "This is official",
      },
    )
  end
end
