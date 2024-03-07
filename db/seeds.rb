# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Account.destroy_all
Plan.destroy_all
Fixed.destroy_all

aaron = User.find_or_initialize_by(nickname: "Aaron", email: "aarondlista@gmail.com")
unless User.exists?(aaron.id)
  aaron.password = "123456"
  aaron.save
  aaron = User.find(aaron.id)
end
jose = User.find_or_initialize_by(nickname: "Jose", email: "joseperalta2910@gmail.com")
unless User.exists?(jose.id)
  jose.password = "123456"
  jose.save
  jose = User.find(jose.id)
end
erika = User.find_or_initialize_by(nickname: "Erika", email: "erika.azuaje2014@gmail.com")
unless User.exists?(erika.id)
  erika.password = "Patico2014"
  erika.save
  erika = User.find(erika.id)
end

users = [aaron, jose, erika]

users.each do |user|
  puts "usuario: #{user.email}"

  puts "creando cuenta para usuario"

  account = Account.new(name: "Mercantil Principal #{user.nickname}", balance: 10_000, color: "#920e0e")
  account.user = user
  account.save

  puts "cuenta creada para #{user.email}:\n nombre: #{account.name}, balance: #{account.balance}"

  puts "creando registros de la cuenta"

  10.times do
    record = Record.new(category: 0, note: "ejemplo")
    record.amount = (100..500).to_a.sample
    record.income = Random.rand(2) == 1 ? true : false
    puts record.income
    record.account = account
    account.balance += record.income ? record.amount : -record.amount
    record.result = account.balance
    account.save
    record.save
  end
end
