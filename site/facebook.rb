# frozen_string_literal: true

module RentBot
  module Site
    class Facebook
      attr_reader :url

      def initialize(group:)
        @url = "https://www.facebook.com/groups/#{group}"
        @browser = Browser.new
        @browser.visit("#{@url}?sorting_setting=CHRONOLOGICAL")

        @browser.fill_in("email", with: "takaisaisei@gmail.com")
        @browser.fill_in("pass", with: "yS2LO5DGr84~")
        @browser.find_button("loginbutton").click
      end

      def refresh
        @browser.refresh
        self
      end

      def last_post
        Facebook::PostBuilder.new(post_el: last_post_el, group_url: @url).create
      end

      private

      def last_post_el
        @browser.first(:css, "div[role='article']", wait: 60)
      end
    end
  end
end
