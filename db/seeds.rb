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

COLORS = %w[#670f22 #9a0526 #E20000 #ff4040 #FF7676
        #082338 #0303B5 #003785 #1465BB #2196F3
        #005200 #007B00 #258D19 #4EA93B #588100]

ACCOUNTS = %w[bancamiga mercantil banplus banesco efectivo]

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

  puts "creando cuentas para usuario"

  ACCOUNTS.each do |acct|
    account = Account.new(name: acct.capitalize, balance: 10_000, color: COLORS.sample)
    account.user = user
    account.save
    puts "cuentas creadas para #{user.email}:\n nombre: #{account.name}, balance: #{account.balance}"
  end

  puts "creando registros de la cuenta"

  10.times do
    record = Record.new(category: 0, note: "ejemplo")
    record.amount = (100..500).to_a.sample
    record.income = Random.rand(2) == 1
    record.account = user.accounts.sample
    record.account.balance += record.income ? record.amount : -record.amount
    record.result = record.account.balance
    record.account.save
    record.save
  end
end
