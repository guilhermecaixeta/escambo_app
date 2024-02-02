namespace :utils do
  desc "Generate users"
  task users_generator: :environment do
    number_of_admins = 10
    admins = []
    puts "Generating #{number_of_admins} admins"
    number_of_admins.times do
      Admin.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: "123456",
        password_confirmation: "123456",
        role: [0,1].sample)
    end
    puts "Admins generated"
  end

end
