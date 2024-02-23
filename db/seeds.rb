# typed: strict
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

current_datetime = DateTime.now
if Category.all.empty?
  puts "Adding default categories"
  Category.upsert_all([
    { description: "Animais e acessórios", created_at: current_datetime, updated_at: current_datetime },
    { description: "Esportes", created_at: current_datetime, updated_at: current_datetime },
    { description: "Para a sua casa", created_at: current_datetime, updated_at: current_datetime },
    { description: "Eletrônicos e celulares", created_at: current_datetime, updated_at: current_datetime },
    { description: "Música e hobbies", created_at: current_datetime, updated_at: current_datetime },
    { description: "Bebês e crianças", created_at: current_datetime, updated_at: current_datetime },
    { description: "Moda e beleza", created_at: current_datetime, updated_at: current_datetime },
    { description: "Veículos e barcos", created_at: current_datetime, updated_at: current_datetime },
    { description: "Imóveis", created_at: current_datetime, updated_at: current_datetime },
    { description: "Empregos e negócios", created_at: current_datetime, updated_at: current_datetime },
  ])
  puts "All categories were added!"
end

if Role.all.empty?
  puts "Adding default roles"
  roles = Rails.configuration.default_roles.map do |role|
    { name: role[:name], created_at: current_datetime, updated_at: current_datetime }
  end
  Role.upsert_all(roles)
  puts "All roles were added!"
end
