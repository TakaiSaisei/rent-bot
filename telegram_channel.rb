# frozen_string_literal: true

module RentBot
  class TelegramChannel
    TOKEN = "6425650298:AAEinyhTl1K1HG7GyWsuVQGw25ihX2Fm57g"
    CHANNEL = "-1002098469086"

    class << self
      def send_plain_message(text)
        safe_send do
          Telegram::Bot::Client.run(TOKEN) do |bot|
            bot.api.send_message(chat_id: CHANNEL, text: text)
          end
        end
      end

      def send_images(images, caption = {})
        safe_send do
          Telegram::Bot::Client.run(TOKEN) do |bot|
            bot.api.sendMediaGroup(chat_id: CHANNEL, media: serialized_images(images, caption))
          end
        end
      end

      private

      def safe_send(&block)
        yield
      rescue Telegram::Bot::Exceptions::ResponseError => e
        raise e if e.response.status != 429

        retry_after = JSON.parse(e.response.body)["parameters"]["retry_after"]
        sleep(retry_after)
        safe_send(&block)
      end

      def serialized_images(images, caption)
        images.map do |image|
          {
            type: "photo",
            media: image,
          }
        end.tap do |ary|
          ary.first.merge!(caption)
        end
      end
    end
  end
end
