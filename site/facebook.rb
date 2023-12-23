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

      def posts
        post_els.filter_map do |el|
          Facebook::PostBuilder.new(post_el: el, group_url: @url).create
        end
      end

      private

      def feed
        @browser.first(:css, "div[role='feed']")
      end

      def post_els
        scroll_down
        # is article and not a comment
        feed.all(:xpath, ".//div[@role='article' and not(@tabindex)]")
      end

      def scroll_down
        sleep 3
        @browser.execute_script("window.scrollBy(0,1000)")
        sleep 3
        @browser.execute_script("window.scrollBy(0,700)")
        sleep 3
      end
    end
  end
end
