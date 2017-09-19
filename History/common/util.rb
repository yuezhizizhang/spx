require 'date'

module QuantUtil
  def to_timestamp(date, format)
    return DateTime.now.to_time.to_i if date.blank?

    DateTime.strptime(date, format).to_time.to_i
  end

  def from_timestamp(timestamp)
    DateTime.strptime(timestamp, '%s')
  end
end