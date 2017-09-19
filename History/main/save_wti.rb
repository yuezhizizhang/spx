require_relative '..\common\util'
require_relative '..\crawler\http_request'
require_relative '..\crawler\wti'

SYMBOL = 'CLZ17'

def download_futures()
  wti = Quant::Wti.new
  #data = wti.download_futures_strikes(SYMBOL)
  data = wti.download_futures_quote(SYMBOL)
  puts data
end

download_futures