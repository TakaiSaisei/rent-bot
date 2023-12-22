# frozen_string_literal: true

module RentBot
  class Post
    attr_reader :id, :url, :source_url, :text, :images

    def initialize(id:, url:, source_url: nil, text: nil, images: [])
      @id = id
      @url = url
      @source_url = source_url
      @text = text
      @images = images
    end
  end
end

