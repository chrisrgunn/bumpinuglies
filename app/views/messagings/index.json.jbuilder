json.array!(@messagings) do |messaging|
  json.extract! messaging, :id, :date, :receiver, :sender, :message
  json.url messaging_url(messaging, format: :json)
end
