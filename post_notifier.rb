module RentBot
  class PostNotifier
    class << self
      def notify(post)
        TelegramChannel.send_images(post.images, caption(post))
      end

      def caption(post)
        {
          caption: <<~HTML.strip,
            <a href="#{post.url}">New post</a>
            <a href="#{post.source_url}">Source</a>

            #{post.text}
          HTML
          parse_mode: "HTML",
        }
      end
    end
  end
end
