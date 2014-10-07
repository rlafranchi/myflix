# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cat1 = Category.create(name: "Comedies")
cat2 = Category.create(name: "Dramas")
Video.create(name: 'Monk', description: 'OCD', small_image_url: '/tmp/monk.jpg', large_image_url: '/tmp/monk_large.jpg', category: cat2)
#6.times do
Video.create(name: 'Family Guy', description: 'Comdey', small_image_url: '/tmp/family_guy.jpg', category: cat1, created_at: 1.day.ago)
Video.create(name: 'South Park', description: 'Colorado', small_image_url: '/tmp/south_park.jpg', category: cat1)
#end

rev = Review.create(rating: 4, content: 'not too bad')
rev2 = Review.create(rating: 3, content: 'pretty good')
user = User.create(email: 'rlafranchi@serenethemes.com', password: 'password', name: 'Rich Bitch')
user.reviews << rev
user.reviews << rev2
Video.all.each do |vid|
  vid.reviews << rev
  vid.reviews << rev2
end
