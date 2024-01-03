# frozen_string_literal: true

module RentBot
  class Browser < SimpleDelegator
    def initialize
      super(Capybara::Session.new(:selenium_firefox_headless))
    end
  end
end
