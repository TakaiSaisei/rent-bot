# frozen_string_literal: true

module RentBot
  class PostRetriever
    DEFAULT_POLL_INTERVAL = 10 * 60

    def initialize(site:, poll_interval: DEFAULT_POLL_INTERVAL)
      @site = site
      @poll_interval = poll_interval
      @on = { new_post: ->(_) {}, error: ->(_) {} }

      yield self if block_given?

      Thread.new do
        start_listening
      end
    end

    def on_new_post(&action)
      @on[:new_post] = action
    end

    def on_error(&action)
      @on[:error] = action
    end

    private

    def start_listening
      last_id = nil

      loop do
        @site.refresh

        current = @site.last_post
        if current.id != last_id
          last_id = current.id
          @on[:new_post].call(current)
        end

        sleep(@poll_interval + jitter)
      end
    rescue StandardError => e
      @on[:error].call(e)
    end

    def jitter
      rand(2.0..7.0)
    end
  end
end
