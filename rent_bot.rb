# frozen_string_literal: true

require "capybara"
require "capybara/sessionkeeper"
require "selenium-webdriver"
require "delegate"
require "telegram/bot"

require_relative "site/facebook/post_builder"
require_relative "site/facebook"
require_relative "browser"
require_relative "launcher"
require_relative "post"
require_relative "post_notifier"
require_relative "post_retriever"
require_relative "telegram_channel"

module RentBot
  Capybara.register_driver :selenium_chrome_headless do |app|
    options = Selenium::WebDriver::Chrome::Options.new

    [
      "no-sandbox",
      "headless",
      "window-size=800x1800",
      "disable-gpu", # https://developers.google.com/web/updates/2017/04/headless-chrome
    ].each { |arg| options.add_argument(arg) }

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
end
