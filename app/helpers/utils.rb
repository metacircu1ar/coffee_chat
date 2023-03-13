module Utils
  def extract_timestamp(timestamp_param)
    timestamp = timestamp_param.nil? ? 0 : timestamp_param.to_i
    Time.at(0, timestamp, :millisecond)
  end

  def to_millisec(timestamp)
    timestamp.to_datetime.strftime('%Q').to_i
  end
end