# frozen_string_literal: true

module RentBot
  class TelegramChannel
    TOKEN = "6425650298:AAEinyhTl1K1HG7GyWsuVQGw25ihX2Fm57g"
    CHANNEL = "-1002098469086"

    class << self
      def send_message(text)
        Telegram::Bot::Client.run(TOKEN) do |bot|
          bot.api.send_message(chat_id: CHANNEL, text: text, parse_mode: "HTML")
        end
      end

      def send_photo(path)
        Telegram::Bot::Client.run(TOKEN) do |bot|
          bot.api.send_photo(chat_id: CHANNEL, photo: Faraday::UploadIO.new(path, "image/png"))
        end
      end

      def send_notification(image_path, post_url, group_url)
        Telegram::Bot::Client.run(TOKEN) do |bot|
          bot.api.send_photo(
            chat_id: CHANNEL,
            photo: Faraday::UploadIO.new(image_path, "image/png"),
            caption: "#{post_url}\n\n#{group_url}"
          )
        end
      end
    end
  end
end
