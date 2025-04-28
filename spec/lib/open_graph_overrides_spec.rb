# frozen_string_literal: true
require_relative "../spec_helper"

RSpec.describe DiscourseOpenGraph::OpenGraphOverrides do
  let(:overrides) { described_class.new }

  before { SiteSettingHelper.load_testing_overrides }

  describe "#overrides" do
    it "returns the overrides as an array" do
      expect(overrides.overrides).to be_an(Array)
      expect(overrides.overrides.size).to eq(2)
    end
  end

  describe "#find_by_url" do
    it "finds the correct override by URL" do
      url = "/tag/news"
      override = overrides.find_by_url(url)
      expect(override).to be_present
      expect(override[:title]).to eq("This is what is going on")
      expect(override[:description]).to eq("This is the news")
    end

    it "finds the correct override by regex" do
      url = "/c/official-category"
      override = overrides.find_by_url(url)
      expect(override).to be_present
      expect(override[:title]).to eq("This is official")
      expect(override[:description]).to eq("This is official")
    end

    it "returns nil if no override is found" do
      url = "/c/non-existent-category"
      override = overrides.find_by_url(url)
      expect(override).to be_nil
    end

    it "finds the correct override in complex cases" do
      url = "/c/products/{anything}/something-containing-ideas"
      SiteSettingHelper.add_json(
        {
          "url" => "/c/products/[^/]+/[^/]*ideas[^/]*/",
          "title" => "This is a product idea",
          "description" => "This is a product idea",
        },
      )
      override = overrides.find_by_url(url)
      expect(override).to be_present
      expect(override[:title]).to eq("This is a product idea")
      expect(override[:description]).to eq("This is a product idea")

      url = "/c/products/something-else/ideas"
      override = overrides.find_by_url(url)
      expect(override).to be_present
      expect(override[:title]).to eq("This is a product idea")
      expect(override[:description]).to eq("This is a product idea")
    end
  end
end
