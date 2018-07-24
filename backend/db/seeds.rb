# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

200.times do
  FactoryBot.create(:phone_number)
end

Group.create([{name: 'SMP 2 SLEMAN'},{name: 'SMK 2 YK'},{name: 'STMIK AKAKOM'},{name: 'TRAH MANGUNHARJO'}])

200.times do |index|
  group_id = Random.rand(0...3)
  user_id = Random.rand(0...199)
  unless UserGroup.exists?(group_id: group_id, user_id: user_id)
    UserGroup.create({group_id: Random.rand(0...3), user_id: Random.rand(0...199)})
  end
end