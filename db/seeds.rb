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
  puts "Adding categories"
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
  Role.upsert_all([
    { name: "administrator", created_at: current_datetime, updated_at: current_datetime },
    { name: "operator", created_at: current_datetime, updated_at: current_datetime },
    { name: "member", created_at: current_datetime, updated_at: current_datetime },
  ])
  puts "All roles were added!"
end

puts "Checking permissions"
controllers = Rails.application.routes.routes
  .map { |r| r.defaults[:controller] }
  .uniq
  .filter { |c| !c.nil? and !c.blank? and !c.match(/(rails|active|action).*/) }

existing_permissions = Permission.all

if existing_permissions.any?
  controllers.delete_if do |controller|
    existing_permissions.any? do |permission|
      permission.name.include?(controller)
    end
  end
end

if controllers.any?
  puts "There is #{controllers.count} permissions to be added"
  puts "Adding permissions"
  upsert_permissions = []
  [:read, :write].each do |action|
    controllers.each do |controller|
      if controller.include?("message") and action == :read
        next
      end
      upsert_permissions << { name: "#{controller}:#{action.to_s}", created_at: current_datetime, updated_at: current_datetime }
    end
  end
  Permission.upsert_all(upsert_permissions)
  puts "All permissions were added!"

  puts "Adding permissions to role"
  roles = Role.all
  permissions = Permission.all

  admin_role = roles.filter { |role| role.name == "administrator" }.first
  operator_role = roles.filter { |role| role.name == "operator" }.first
  member_role = roles.filter { |role| role.name == "member" }.first

  puts "Adding default permissions to roles"
  permissions.each do |permission|
    admin_role.permissions << permission
  end

  permissions.filter { |permission| permission.name.match?(/(?:backoffice\/(categories|message))|(.*:read)/) }.each do |permission|
    operator_role.permissions << permission
  end

  permissions.filter { |permission| permission.name.match?(/(site\/home:(read|write))/) }.each do |permission|
    member_role.permissions << permission
  end

  admin_role.save!
  operator_role.save!
  member_role.save!
  puts "Permissions added to roles"
else
  puts "There is no permissions to be added"
end

if User.all.empty?
  puts "Adding admin master"
  admin = User.create(
    name: "Admin master",
    email: "admin@admin.com",
    password: "123456",
    password_confirmation: "123456",
    confirmed_at: current_datetime,
    role_ids: [admin_role.id],
  )
  admin.skip_confirmation!
  admin.skip_confirmation_notification!
  puts "Admin master was added!"
end
