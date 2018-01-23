require_relative '..\common\util'
require_relative '..\crawler\http_request'
require_relative '..\crawler\spx'
require_relative '..\crawler\mongodb'

spx = Quant::Spx.new
db = Quant::MongoDB.new('spx')

def download_kseries(spx, db)
  today = Date.today.strftime('%Y-%m-%d')
  yesterday = Date.today.prev_day.strftime('%Y-%m-%d')

  data = spx.download_kseries(yesterday, today)
  puts db.insert_kseries(data, 1)
end

def download_options(spx, db)
  opts = spx.download_options
  return nil if opts.blank?

  row = opts.last
  date = row[0]
  puts date
  params = {"pcr": row[1].strip, "put": row[2].strip, "call": row[3].strip, "vol": row[4].strip}
  puts params
  db.update_kseries(date, params)
end

def download_options_all(spx, db)
  opts = spx.download_options
  return nil if opts.blank?

  opts.each_with_index { |row, index|
    if (index > 1)
      date = row[0]
      puts date
      params = {"pcr": row[1].strip, "put": row[2].strip, "call": row[3].strip, "vol": row[4].strip}
      puts params
      db.update_kseries(date, params)
    end
  }
end

download_kseries(spx, db)
download_options(spx, db)
