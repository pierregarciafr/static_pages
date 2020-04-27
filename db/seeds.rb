# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'erasing db'
User.destroy_all

puts 'creating users'
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
User.create!(name:                  'Example User',
             email:   'example@railstutorial.org',
             password:              'password',
             password_confirmation: 'password',
             admin: false,
             activated: true,
             activated_at: Time.zone.now
             )

# Generate a bunch of additional users.
99.times do |n|
  puts "#{n + 1}th user being created" if n % 10 == 0
  name = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name:        name,
               email:       email,
               password:    password,
               password_confirmation: password,
               admin: false,
               activated: true,
               activated_at: Time.zone.now
               )
end
puts "Task finished !"
