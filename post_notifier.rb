# frozen_string_literal: true

module RentBot
  class PostNotifier
    class << self
      def notify(post)
        if post.images.empty?
          TelegramChannel.send_html_message(html_text(post))
        else
          TelegramChannel.send_images(post.images, caption(post))
        end
      end

      def html_text(post)
        <<~HTML.strip
          <a href="#{post.url}">New post</a>
          <a href="#{post.source_url}">Source</a>

          #{post.text}
        HTML
      end

      def caption(post)
        {
          caption: html_text(post)[0..1023],
          parse_mode: "HTML",
        }
      end
    end
  end
end
