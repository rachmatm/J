class Time
  def as_json(options = {})
    self.utc.iso8601
  end
end