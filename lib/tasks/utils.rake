require "open-uri"

namespace :utils do
  desc "Setup development environment"
  task setup_development: :environment do
    puts "Dropping DB #{%x(rails db:drop)}"
    puts "Creating DB #{%x(rails db:create)}"
    puts "Migrating DB #{%x(rails db:migrate)}"
    puts "Seeding DB #{%x(rails db:seed)}"
    puts "Adding permissions #{%x(rails utils:add_permissions_if_dont_exists)}"
    puts "Adding permissions to roles #{%x(rails utils:add_permissions_to_roles)}"
    puts "Adding default user #{%x(rails utils:add_default_user)}"
    puts "Adding admins\n #{%x(rails utils:admins_generator)}"
    puts "Adding member\n #{%x(rails utils:members_generator)}"
    puts "Adding advertisements #{%x(rails utils:ads_generator)}"
    puts "Adding images to advertisements #{%x(rails utils:add_image_to_ads)}"
  end

  desc "Generate admins"
  task admins_generator: :environment do
    number_of_users = 10
    roles = Role.where.not(name: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name]).all

    puts "Generating #{number_of_users} admins"
    utc_now = DateTime::now
    number_of_users.times do
      user = Admin.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
        confirmed_at: utc_now,
        role_ids: [roles.shuffle.sample.id],
      )

      user.skip_confirmation!
      user.skip_confirmation_notification!
    end
    puts "Admins generated"
  end

  desc "Generate members"
  task members_generator: :environment do
    number_of_users = 50
    member_role = Role.find_by(name: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name])

    puts "Generating #{number_of_users} members"
    utc_now = DateTime::now
    number_of_users.times do
      user = Member.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
        confirmed_at: utc_now,
        role_ids: [member_role.id],
      )

      user.skip_confirmation!
      user.skip_confirmation_notification!
    end
    puts "Admins generated"
  end

  desc "Generate advertisements"
  task ads_generator: :environment do
    number_of_ads = 100
    utc_now = DateTime::now
    categories = Category.all
    members = Member.all

    puts "Generating #{number_of_ads} advertisements"

    ads = number_of_ads.times.map { |i|
      index = i + 1
      advertisement = {
        id: index,
        title: Faker::Commerce.product_name,
        description: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4),
        price_cents: Faker::Commerce.price(range: 10..19999.99, as_string: true),
        category_id: categories.shuffle.sample.id,
        user_id: members.shuffle.sample.id,
        created_at: utc_now,
        updated_at: utc_now,
      }
    }

    Advertisement.insert_all!(ads)
    puts "Ads generated"
  end

  desc "Adding images to advertisements"
  task add_image_to_ads: :environment do
    ads = Advertisement.all

    puts "Adding images to advertisements"
    total = ads.count
    ads.each.with_index(1) do |ad, index|
      puts "Adding image #{index}/#{total}"
      ad.picture.attach(
        io: open(Faker::LoremFlickr.unique.image),
        filename: "#{ad.id}.jpg",
      )
      Faker::LoremFlickr.unique.clear
      ad.save!
    end
  end

  desc "Adds the permissions if they doesn't exist and check if a newer permissions has appeared"
  task add_permissions_if_dont_exists: :environment do
    puts "Checking permissions"
    controllers = Rails.application.routes.routes
      .map { |r| r.defaults[:controller] }
      .uniq
      .filter { |c| !c.nil? and !c.blank? and !c.match?(/(rails|active|action|(devise\/(confirmations|registrations|passwords))).*/) }

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
      current_datetime = DateTime.now
      upsert_permissions = []
      [:read, :write].each do |action|
        controllers.each do |controller|
          if (controller.match?(/(message|sessions)/) and action == :read) or
             (controller.match?(/backoffice\/(dashboard|permissions|home)/) and action == :write)
            next
          end
          upsert_permissions << { name: "#{controller}:#{action.to_s}", created_at: current_datetime, updated_at: current_datetime }
        end
      end
      Permission.upsert_all(upsert_permissions)
      puts "All permissions were added!"
    else
      puts "There is no permissions to be added"
    end
  end

  desc "Adds the permissions to roles"
  task add_permissions_to_roles: :environment do
    roles = Role.where(name: Rails.configuration.default_roles.map { |r| r[:name] })
    permissions = Permission.all

    if permissions.nil? or permissions.empty?
      raise "Permissions cannot be empty"
    end

    puts "Adding default permissions to roles"
    admin_role = roles.filter {
      |role|
      role.name == Rails.configuration.default_roles.find { |r| r[:is_admin] }[:name]
    }.first
    permissions.each do |permission|
      admin_role.permissions << permission
    end

    operator_role = roles.filter {
      |role|
      role.name == Rails.configuration.default_roles.find { |r| r[:is_opt] }[:name]
    }.first
    permissions.filter {
      |permission|
      permission.name.match?(/(?:backoffice\/(categories|message))|(.*:read)/)
    }.each do |permission|
      operator_role.permissions << permission
    end

    member_role = roles.filter {
      |role|
      role.name == Rails.configuration.default_roles.find { |r| r[:is_member] }[:name]
    }.first
    permissions.filter {
      |permission|
      permission.name.match?(/(site\/home:(read|write))/)
    }.each do |permission|
      member_role.permissions << permission
    end

    admin_role.save!(validate: false)
    operator_role.save!(validate: false)
    member_role.save!(validate: false)
    puts "Permissions added to roles"
  end

  desc "Adds the defaut user: admin master"
  task add_default_user: :environment do
    current_datetime = DateTime.now
    role = Role.select(:id).find_by(name: Rails.configuration.default_roles.find { |r| r[:is_admin] }[:name])
    puts "Adding admin master"
    admin = Admin.create(
      name: "Admin master",
      email: "admin@admin.com",
      password: "123456",
      password_confirmation: "123456",
      confirmed_at: current_datetime,
      role_ids: [role.id],
    )
    admin.skip_confirmation!
    admin.skip_confirmation_notification!
    puts "Admin master was added!"
  end
end
