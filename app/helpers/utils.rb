module Utils
  def extract_timestamp(timestamp_param)
    timestamp = timestamp_param.nil? ? 0 : timestamp_param.to_i
    Time.at(timestamp)
  end
end