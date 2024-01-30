# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

current_datetime = DateTime.now
Category.upsert_all([
  {id: 1, description: "Animais e acessórios", created_at: current_datetime, updated_at: current_datetime},
  {id: 2, description: "Esportes", created_at: current_datetime, updated_at: current_datetime},
  {id: 3, description: "Para a sua casa", created_at: current_datetime, updated_at: current_datetime},
  {id: 4, description: "Eletrônicos e celulares", created_at: current_datetime, updated_at: current_datetime},
  {id: 5, description: "Música e hobbies", created_at: current_datetime, updated_at: current_datetime},
  {id: 6, description: "Bebês e crianças", created_at: current_datetime, updated_at: current_datetime},
  {id: 7, description: "Moda e beleza", created_at: current_datetime, updated_at: current_datetime},
  {id: 8, description: "Veículos e barcos", created_at: current_datetime, updated_at: current_datetime},
  {id: 9, description: "Imóveis", created_at: current_datetime, updated_at: current_datetime},
  {id: 10, description: "Empregos e negócios", created_at: current_datetime, updated_at: current_datetime}
])
