json.array! @users do |user|
  json.name user.name
  json.poj_user user.poj_user
  json.aoj_user user.aoj_user
end
