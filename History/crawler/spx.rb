require 'json'
require 'csv'

module Quant
  class Spx
    include QuantUtil

    FOREX_URL = 'http://tvc4.forexpros.com/64235d66ca6ecdd831c83e562598cf6a/0/70/70/31/history'
    CBOE_URL = 'http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/spxpc.csv'
    TIME_FORMAT = '%Y-%m-%d'

    SYMBOL = '8839'

    def download_kseries(from, to, type = 'D')
      query = make_http_params(from, to, type)
      params = {url: FOREX_URL, query: query}

      response = HttpRequest.http_download(params)
      return nil if response.blank? || response.code != '200'

      return JSON.parse(response.body)
    end

    def download_options
      params = {url: CBOE_URL}

      response = HttpRequest.http_download(params)
      return nil if response.blank? || response.code != '200'

      CSV.parse(response.body)
    end

    def make_http_params(from, to, type)
      start = to_timestamp(from, TIME_FORMAT)
      stop = to_timestamp(to, TIME_FORMAT)

      {
          symbol: SYMBOL,
          resolution: type,
          from: start,
          to: stop
      }
    end
  end
end