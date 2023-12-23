# frozen_string_literal: true

module RentBot
  class SizedArray < Array
    def initialize(size)
      @size = size
      super()
    end

    def <<(el)
      shift if size >= @size
      super(el)
    end
  end
end
