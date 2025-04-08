# frozen_string_literal: true

describe DiscourseOpenGraph do
  include ApplicationHelper

  fab!(:news_tag) { Fabricate(:tag, name: "news") }
  class SiteSettingHelper
    def self.add_json(*jsons)
      jsons.each do |json|
        site_setting = JSON.parse SiteSetting.open_graph_overrides
        site_setting << json
        SiteSetting.open_graph_overrides = site_setting.to_json
      end
    end
  end

  before do
    SiteSetting.discourse_open_graph_enabled = true
    SiteSettingHelper.add_json(
      {
        "url" => "/tag/news",
        "title" => "This is what is going on", # normally it would say Topics tagged news
        "description" => "This is the news", # normally it would say Topics tagged news
      },
      { # this is to test regex compatibility
        # any url that has "official" in the name
        "url" => "/*.official.*",
        "title" => "This is the official category",
        "description" => "This is the official category",
      },
    )
  end

  describe "with meta_data_content modifier" do
    it "overrides the meta tags" do
      # Create a new topic with the tag "news"
      topic = Fabricate(:topic, title: "This is what is going on", tags: [news_tag])
      post = Fabricate(:post, topic: topic)

      meta_tags = crawlable_meta_data(url: news_tag.url)
      puts meta_tags

      expect(meta_tags["og:title"]).to eq("This is what is going on")
      expect(meta_tags["og:description"]).to eq("This is the news")

      meta_tags = crawlable_meta_data(url: topic.url)
      expect(meta_tags["og:title"]).to eq("This is what is going on")
      expect(meta_tags["og:description"]).to eq("This is the news")
    end

    it "works with regex" do
      official_post =
        Fabricate(:post, topic: Fabricate(:topic, title: "This is the official category"))

      meta_tags = crawlable_meta_data(url: official_post.url)
      expect(meta_tags["og:title"]).to eq("This is the official category")
      expect(meta_tags["og:description"]).to eq("This is the official category")
      expect(meta_tags["og:url"]).to eq(official_post.url)
    end
  end
end
