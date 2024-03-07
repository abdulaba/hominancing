# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
aaron = User.new(nickname: "Aaron", email: "aarondlista@gmail.com", password: "123456")
jose = User.new(nickname: "Jose", email: "joseperalta2910@gmail.com", password: "123456")
erika = User.new(nickname: "Erika", email: "erika.azuaje2014@gmail.com", password: "Patico2014")

users = [aaron, jose, erika]

users.each do |user|
  puts "usuario: #{user.email}"

  puts "creando cuenta para usuario"

  account = Account.new(name: "Mercantil Principal", balance: 10_000, color: "#920e0e")
  account.user = user
  account.save

  puts "cuenta creada para #{user.email}:\n nombre: #{account.name}, balance: #{account.balance}"

  puts "creando registros de la cuenta"

  10.times do
    amount = (100..500).to_a.sample * [1, -1].sample
    record = Record.new(amount: amount, category: 0, note: "ejemplo")
    record.account = account
    account.balance += record.amount
    account.save
    record.save
  end
end
