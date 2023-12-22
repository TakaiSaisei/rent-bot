# frozen_string_literal: true

module RentBot
  module Site
    class Facebook
      class PostBuilder
        def initialize(post_el:, group_url:)
          @post_el = post_el
          @group_url = group_url
        end

        def create
          Post.new(id: id, url: url, source_url: @group_url, text: text, images: images)
        end

        private

        def id
          @id ||= url.split("/").last.to_i
        end

        def url
          @url ||=
            begin
              url = @post_el.first(:xpath, "//a[starts-with(@href, '#{post_url_pattern}')]")["href"]
              useless_from = url.index("?") - 2
              url.slice(0..useless_from)
            end
        end

        def text
          more_button.click
          @post_el.first(:xpath, ".//div[@data-ad-comet-preview='message']").text
        end

        def images
          @post_el.all(:xpath, ".//img[starts-with(@src, 'https://scontent')]").map { _1["src"] }
        end

        def more_button
          @post_el.first(:xpath, ".//div[@role='button' and not(@aria-haspopup='menu')]")
        end

        def post_url_pattern
          "#{@group_url}/posts"
        end
      end
    end
  end
end
