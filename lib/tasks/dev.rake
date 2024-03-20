require "open-uri"

namespace :dev do
  desc "Setup development environment"
  task setup: :environment do
    puts "Dropping DB #{%x(rails db:drop)}"
    puts "Creating DB #{%x(rails db:create)}"
    puts "Migrating DB #{%x(rails db:migrate)}"
    puts "Seeding DB #{%x(rails db:seed)}"
    puts "Adding permissions #{%x(rails dev:add_permissions_if_dont_exists)}"
    puts "Adding permissions to roles #{%x(rails dev:add_permissions_to_roles)}"
    puts "Adding default user #{%x(rails dev:add_default_users)}"
    puts "Adding admins\n #{%x(rails dev:admins_generator)}"
    puts "Adding member\n #{%x(rails dev:members_generator)}"
    puts "Adding advertisements #{%x(rails dev:ads_generator)}"
    puts "Adding images to advertisements #{%x(rails dev:add_image_to_ads)}"
    puts "Fixing pk sequence"
    ActiveRecord::Base.connection.tables.each do |table_name|
      ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
    end
  end

  desc "Generate admins"
  task admins_generator: :environment do
    number_of_users = 10
    roles = Role.where.not(name: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name]).all
    default_password = Rails.configuration.default_password

    puts "Generating #{number_of_users} admins"
    utc_now = DateTime::now
    number_of_users.times do
      user = Admin.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: default_password,
        password_confirmation: default_password,
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
    default_password = Rails.configuration.default_password
    puts "Generating #{number_of_users} members"
    utc_now = DateTime::now
    number_of_users.times do
      user = Member.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: default_password,
        password_confirmation: default_password,
        confirmed_at: utc_now,
        role_ids: [member_role.id],
      )

      user.skip_confirmation!
      user.skip_confirmation_notification!
    end
    puts "Members generated"
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
        finish_date: utc_now + Random.rand(90),
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
    default_permissions = Rails.configuration.default_permissions

    existing_permissions = Permission.all

    if existing_permissions.any?
      default_permissions.delete_if do |authorization|
        existing_permissions.any? { |permission| permission.name.match?(authorization) }
      end
    end

    if default_permissions.any?
      puts "There is #{default_permissions.count} permissions to be added"
      puts "Adding permissions"
      current_datetime = DateTime.now
      upsert_permissions = []
      default_permissions.each do |auth|
        upsert_permissions << { name: auth, created_at: current_datetime, updated_at: current_datetime }
      end
      Permission.upsert_all(upsert_permissions)
      puts "All permissions were added!"
    else
      puts "There is no permissions to be added"
    end
  end

  desc "Add permissions to roles"
  task add_permissions_to_roles: :environment do
    roles = Role.includes(:permissions).where(name: Rails.configuration.default_roles.map { |r| r[:name] })
    existing_permissions = Permission.all

    if existing_permissions.nil? or existing_permissions.empty?
      raise "permissions cannot be empty"
    end

    puts "Adding default permissions to roles"
    roles.each do |role|
      default_role = Rails.configuration.default_roles.find { |r| r[:name] == role.name }
      existing_permissions.each do |existing_permission|
        next if role.permissions.any? do |permission_role| permission_role.name == existing_permission.name end
        next if default_role[:except_permissions].any?(existing_permission.name)
        next unless default_role[:permissions].any? do |default_permission|
          default_permission.match?(/(\*|#{existing_permission.name})/)
        end

        role.permissions << existing_permission
      end
      role.save!(validate: false)
    end

    puts "Permissions added to roles"
  end

  desc "Adds the defaut user: admin master"
  task add_default_users: :environment do
    current_datetime = DateTime.now
    default_password = Rails.configuration.default_password

    puts "Adding admin master"
    admin_role = Role.select(:id).find_by(name: Rails.configuration.default_roles.find { |r| r[:is_admin] }[:name])
    admin = Admin.create(
      name: "Admin master",
      email: "admin.master@acme.com",
      password: default_password,
      password_confirmation: default_password,
      confirmed_at: current_datetime,
      role_ids: [admin_role.id],
    )
    admin.skip_confirmation!
    admin.skip_confirmation_notification!
    puts "Admin master was added!"

    puts "Adding default member"
    member_role = Role.select(:id).find_by(name: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name])
    member = Member.create(
      name: "Default Member",
      email: "member.default@acme.com",
      password: default_password,
      password_confirmation: default_password,
      confirmed_at: current_datetime,
      role_ids: [member_role.id],
    )
    member.skip_confirmation!
    member.skip_confirmation_notification!
    puts "Default member was added!"
  end
end
