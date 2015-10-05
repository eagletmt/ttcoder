ActiveSupport::Notifications.subscribe('sql.active_record') do |_name, start, finish, _id, payload|
  next if payload[:name] == 'SCHEMA'
  duration_ms = (finish - start) * 1000
  Fluent::Logger.post('sql', duration: duration_ms, name: payload[:name], sql: payload[:sql])
end

ActiveSupport::Notifications.subscribe('process_action.action_controller') do |_name, start, finish, _id, payload|
  Fluent::Logger.post('process_action', payload.merge(duration: ((finish - start) * 1000)))
end
