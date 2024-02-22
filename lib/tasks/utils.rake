require "open-uri"

namespace :utils do
  desc "Setup development environment"
  task setup_development: :environment do
    puts "Dropping DB #{%x(rails db:drop)}"
    puts "Creating DB #{%x(rails db:create)}"
    puts "Migrating DB #{%x(rails db:migrate)}"
    puts "Seeding DB #{%x(rails db:seed)}"
    puts "Adding users #{%x(rails utils:users_generator)}"
    puts "Adding advertisements #{%x(rails utils:ad_generator)}"
    puts "Adding images to advertisements #{%x(rails utils:add_image_to_ads)}"
  end

  desc "Generate users"
  task users_generator: :environment do
    number_of_users = 10
    admin_and_op_roles = Role.where(id: [1, 2])

    puts "Generating #{number_of_users} users"
    utc_now = DateTime::now
    number_of_users.times do
      user = User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
        confirmed_at: utc_now,
        role_ids: [admin_and_op_roles.shuffle.sample.id],
      )

      user.skip_confirmation!
      user.skip_confirmation_notification!
    end
    puts "Admins generated"

    puts "Generating #{number_of_users} members"
    member_role = Role.find(3)
    number_of_users.times do
      Member.create!(
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
      )
    end
    puts "Members generated"
  end

  desc "Generate advertisements"
  task ad_generator: :environment do
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
        price_cents: Faker::Commerce.price(range: 10..10000.0, as_string: true),
        category_id: categories.sample.id,
        member_id: members.sample.id,
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
end
