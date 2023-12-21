# frozen_string_literal: true

module RentBot
  class Launcher
    POOL_PERIOD = 10 * 60

    def initialize; end

    def start
      %w[flats4friends flatsforfriendsmsk cityrent].map do |group|
        Thread.new do
          site = Site::Facebook.new(group: group).login

          loop do
            site.refresh

            if (post_url = site.new_post_url)
              # TelegramChannel.send_message(notification(group, site.url, post_url))
              # TelegramChannel.send_photo(site.screenshot)
              TelegramChannel.send_notification(site.screenshot, post_url, site.url)
            end

            sleep(POOL_PERIOD + jitter)
          end
        rescue StandardError => e
          TelegramChannel.send_message("#{e.class}: #{e.message}")
          raise e
        end.tap { sleep(jitter) }
      end.each(&:join)
    end

    private

    def jitter
      rand(2.0..7.0)
    end

    def notification(group, site_url, post_url)
      <<~EOT.strip
        New post in <a href='#{site_url}'>#{group}</a>

        <a href='#{post_url}'>Link</a>
      EOT
    end
  end
end
