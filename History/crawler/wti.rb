require 'json'
require 'nokogiri'
require 'open-uri'
require 'openssl'

module Quant
  class Wti

    BARCHART_URL = 'https://core-api.barchart.com/v1/quotes/get'

    def download_futures_quote(symbol)
      url = "https://www.barchart.com/futures/quotes/#{symbol}/options"
      page = Nokogiri::HTML(open(url))
      puts page.class
      
    end

    def download_futures_strikes(symbol)
      query = make_http_params(symbol)
      params = {url: BARCHART_URL, query: query}

      response = HttpRequest.http_download(params)
      return nil if response.blank? || response.code != '200'

      return JSON.parse(response.body)
    end

    def make_http_params(symbol)
      {
          symbol: symbol,
          list: 'futures.options',
          fields: 'strike,openPrice,highPrice,lowPrice,lastPrice,priceChange,volume,openInterest,premium,tradeTime,symbolCode,symbolType',
          raw: '1'
      }
    end
  end
end
