# frozen_string_literal: true

100.times do |_n|
  name  = Faker::Sports::Basketball.player
  email = Faker::Internet.email
  password = 'foobar'

  User.create(
    user_name: name,
    email: email,
    password: password
  )
end

100.times do |_n|
  body       = Faker::Games::Pokemon.name
  user_id    = 1
  target_age = '1'

  Content.create(
    user_id: user_id,
    body: body,
    target_age: target_age
  )
end
