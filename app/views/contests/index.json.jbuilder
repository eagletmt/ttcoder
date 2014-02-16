json.array!(@contests) do |contest|
  json.extract! contest, :name
  json.url contest_url(contest, format: :json)
end