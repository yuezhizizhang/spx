require 'csv'

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
  pcr = sprintf("%.02f", (doc[:pcr].blank? ? '0' : doc[:pcr].to_f))
  volume = sprintf("%d", (doc[:vol].blank? ? '0' : doc[:vol]))
  [date, open, close, high, low, pcr, volume]
end

def read_db(db)
  today = Date.today.strftime('%Y-%m-%d')
  results = db.query_kseries('2015-1-1', today)
  results
end

def query_data(db, results)
  results.each { |doc|
    data = format_spx(doc)
    puts "#{data[0]} => #{data[1]} #{data[2]} #{data[3]} #{data[4]} #{doc[:pcr]} #{doc[:put]} #{doc[:call]} #{doc[:vol]}"
  }
end

def write_data(db, results)
  CSV.open("../../Charts/data.csv", "w") do |csv|
    csv << ['Date', 'Open', 'Close', 'High', 'Low',  'Pcr', 'Volume']
    results.each { |doc|
      data = format_spx(doc)
      csv << [data[0], data[1], data[2], data[3], data[4],  data[5], data[6]]
    }
  end

end

data = read_db(db)
query_data(db, data)
write_data(db, data)