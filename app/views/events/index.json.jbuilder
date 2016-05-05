json.array!(@events) do |event|
  json.extract! event, :id, :date, :location, :details
  json.url event_url(event, format: :json)
end
