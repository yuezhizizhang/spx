require_relative '..\common\util'
require_relative '..\crawler\mongodb'

db = Quant::MongoDB.new('spx')

def from_timestamp(timestamp)
  DateTime.strptime("#{timestamp}", '%s').strftime('%Y-%m-%d')
end

def format_spx(doc)
  date = from_timestamp(doc[:t])
  open = sprintf("%.02f", doc[:o])
  close = sprintf("%.02f", doc[:c])
  high = sprintf("%.02f", doc[:h])
  low = sprintf("%.02f", doc[:l])
  [date, open, close, high, low, doc["ema3"], doc["ema13"], doc["ema34"]]
end

def ema(data, period)
  return if data.blank? || period < 1

  mul = 2.0 / (period + 1)
  key = "ema#{period}"
  puts key

  avg = 0;
  data.each_with_index { |item, index|
    close = item[:c].to_f

    if index < period - 1
      avg += close
    elsif index == (period -1)
      avg = (avg / period).round(2)
      item[key] = avg
      puts item.object_id
    else
      avg = ((item[:c].to_f - avg) * mul + avg).round(2)
      item[key] = avg
    end
  }
end

def query_data(results)
  results.each { |doc|
    #puts doc
    data = format_spx(doc)
    #puts "#{data[0]} => #{data[1]} #{data[2]} #{data[3]} #{data[4]} #{data[5]} #{data[6]} #{data[7]}"
  }
end

results = db.query_kseries_all
ema(results, 3)
ema(results, 13)
ema(results, 34)
query_data(results)