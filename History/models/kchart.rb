module Quant
  class KChart

    attr_reader :open,
                :close,
                :low,
                :high

    def initialize(hash)
      @date = hash.fetch(:date, nil)
      @open = hash.fetch(:open, nil)
      @close = hash.fetch(:close, nil)
      @low = hash.fetch(:low, nil)
      @high = hash.fetch(:high, nil)
    end

    def date
      @date.strftime('%Y-%m-%d')
    end
  end
end