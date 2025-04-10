# frozen_string_literal: true
require_relative "../spec_helper"

RSpec.describe DiscourseOpenGraph do
  fab!(:news_tag) { Fabricate(:tag, name: "news") }
  fab!(:category)

  def og_url
    response.body.match(/<meta property="og:url" content="(.*?)"/)[1].to_s
  end

  def og_title
    response.body.match(/<meta property="og:title" content="(.*?)"/)[1].to_s
  end

  def og_description
    response.body.match(/<meta property="og:description" content="(.*?)"/)[1].to_s
  end

  def twitter_title
    response.body.match(/<meta name="twitter:title" content="(.*?)"/)[1].to_s
  end

  def twitter_description
    response.body.match(/<meta name="twitter:description" content="(.*?)"/)[1].to_s
  end

  before do
    SiteSetting.discourse_open_graph_enabled = true
    SiteSettingHelper.load_testing_overrides
  end

  context "with meta_data_content modifier" do
    it "only overrides the meta tags for `news` tags" do
      topic_title = "Topic where things are going on"
      topic = Fabricate(:topic, title: topic_title, tags: [news_tag])

      get news_tag.url

      expect(og_title).to eq("This is what is going on")
      expect(og_description).to eq("This is the news")

      get topic.url

      expect(og_title).to eq(topic_title)

      get category.url

      expect(og_title).to eq(category.name)
    end

    it "works with regex" do
      official_post = Fabricate(:post, topic: Fabricate(:topic, title: "This is a official post"))

      get official_post.url

      expect(og_title).to eq("This is official")
      expect(og_description).to eq("This is official")

      official_category =
        Fabricate(:category, name: "This is an official category", slug: "official-category")

      get official_category.url
      expect(og_title).to eq("This is official")

      official_tag = Fabricate(:tag, name: "official-tag")

      get official_tag.url
      expect(og_title).to eq("This is official")
      expect(og_description).to eq("This is official")
    end

    it "also works with Twitter meta tags" do
      official_post = Fabricate(:post, topic: Fabricate(:topic, title: "This is a official post"))
      get official_post.url

      expect(twitter_title).to eq("This is official")
      expect(twitter_description).to eq("This is official")
    end

    it "does not affect the url meta tag" do
      official_post = Fabricate(:post, topic: Fabricate(:topic, title: "This is a official post"))
      get official_post.url

      expect(og_url).to eq("#{Discourse.base_url_no_prefix}#{official_post.url}")
    end
  end
end
