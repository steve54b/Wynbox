json.array!(@calendars) do |calendar|
  json.extract! calendar, :id, :title, :description, :date, :time
  json.url calendar_url(calendar, format: :json)
end
