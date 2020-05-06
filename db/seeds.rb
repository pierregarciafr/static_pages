# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'erasing Relationship DB'
Relationship.destroy_all
puts 'erasing Micropost DB'
Micropost.destroy_all
puts 'erasing User DB'
User.destroy_all


puts 'creating admin user'
# Creating MY user
User.create!(name:                  'Pierrounet',
             email:   'pierregcode@gmail.com',
             password:              'password',
             password_confirmation: 'password',
             admin: true,
             activated: true,
             activated_at: Time.zone.now
             )

# Creating a main sample user
puts 'creating 2nd user'
User.create!(name:                  'Example User',
             email:   'example@railstutorial.org',
             password:              'password',
             password_confirmation: 'password',
             activated: true,
             activated_at: Time.zone.now
             )

# Generate a bunch of additional users.
puts 'Generate a bunch of additional users.'
99.times do |n|
  print '.'
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name:        name,
               email:       email,
               password:    password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now
               )
end

puts 'Creating microposts'

users = User.order(:created_at).take(6)

50.times do
  print '.'
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create(content: content) }
end

puts 'Creating relationships'

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

puts "Task finished !"
