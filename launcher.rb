# frozen_string_literal: true

module RentBot
  class Launcher
    def initialize; end

    def start
      %w[flats4friends flatsforfriendsmsk cityrent].map do |group|
        site = Site::Facebook.new(group: group)

        PostRetriever.new(site: site) do |retriever|
          retriever.on_new_post do |post|
            PostNotifier.notify(post)
          end

          retriever.on_error do |e|
            TelegramChannel.send_plain_message(e.inspect)
            raise e
          end
        end
      end
    end
  end
end
