# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'erasing db'
User.destroy_all

# puts 'creating users'

# user1 = User.new(id: 1, name: "Rails Tutorial", email: "railstutorial@example.com", password: 'password')
#  #<User:0x00007fb338e98430
# user2 = User.new(id: 2, name: "pierre garcia", email: "pg.pierre.garcia@free.fr", password: 'password')

# [user1, user2].each do |var|
#    var.save
#    var.valid? ? 'valide' : 'not valid'
# end
