# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.find(1)

puts "usuario: #{user.email}"

puts "creando cuenta para usuario"

account = Account.new(name: "Mercantil Principal", balance: 10_000)
account.user = user
account.save

puts "cuenta creada para #{user.email}:\n nombre: #{account.name}, balance: #{account.balance}"

puts "creando registros de la cuenta"

10.times do
  amount = (100..500).to_a.sample * [1, -1].sample
  record = Record.new(amount: amount, category: 0, note: "ejemplo")
  record.account = account
  puts record.valid?
  puts record.errors.messages
end
