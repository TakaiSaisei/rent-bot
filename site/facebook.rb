# frozen_string_literal: true

module RentBot
  module Site
    class Facebook
      attr_reader :url

      def initialize(group:)
        @url = "https://www.facebook.com/groups/#{group}"
        @browser = Browser.new
        @browser.visit("#{@url}?sorting_setting=CHRONOLOGICAL")

        @last_post_text = nil
      end

      def refresh
        @browser.refresh
        self
      end

      def login
        @browser.fill_in("email", with: "takaisaisei@gmail.com")
        @browser.fill_in("pass", with: "yS2LO5DGr84~")
        @browser.find_button("loginbutton").click
        self
      end

      def new_post_url
        if last_post_text != @last_post_text
          @last_post_text = last_post_text
          last_post_url
        end
      end

      def screenshot
        path = screenshot_path
        @browser.save_screenshot(path)
        path
      end

      private

      def last_post
        @browser.first(:xpath, "//div[@role='article']", wait: 60)
      end

      def last_post_url
        url = last_post.first(:xpath, "//a[starts-with(@href, '#{post_url_pattern}')]")["href"]
        useless_from = s.index("?") - 2
        url.slice(0..useless_from)
      end

      def last_post_text
        divs = last_post.all(:xpath, "//div[@style='text-align: start;']")
        divs.first(3).map(&:text).join
      end

      def post_url_pattern
        "#{@url}/posts"
      end

      def screenshots_path
        File.expand_path("tmp/screenshots", Dir.pwd)
      end

      def screenshot_path
        count = Dir[File.join(screenshots_path, "**", "*")].count { |file| File.file?(file) }
        File.expand_path("#{count}.png", screenshots_path)
      end
    end
  end

end
