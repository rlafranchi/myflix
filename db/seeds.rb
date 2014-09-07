# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cat = Category.find_by(name: "Comedies")
# Video.create(name: 'Monk', description: 'OCD', small_image_url: '/tmp/monk.jpg', large_image_url: '/tmp/monk_large.jpg')
6.times do
  Video.create(name: 'Family Guy', description: 'Comdey', small_image_url: '/tmp/family_guy.jpg', categories: [cat], created_at: 1.day.ago)
  Video.create(name: 'South Park', description: 'Colorado', small_image_url: '/tmp/south_park.jpg', categories: [cat])
end
# Category.create(name: 'Comedies')
# Category.create(name: 'Dramas')
