User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  name  = Faker::Name.name
  author  = Faker::Name.name
  celebrity  = Faker::Name.name
  introduction = Faker::Lorem.sentence(5)
  reference = Faker::Lorem.sentence(5)
  users.each { |user| user.posts.create!(name: name, author: author, celebrity: celebrity, introduction: introduction, reference: reference) }
end