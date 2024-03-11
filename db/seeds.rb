Account.destroy_all
Plan.destroy_all
Fixed.destroy_all

COLORS = %w[#670f22 #9a0526 #E20000 #ff4040 #FF7676
        #082338 #0303B5 #003785 #1465BB #2196F3
        #005200 #007B00 #258D19 #4EA93B #588100]

ACCOUNTS = %w[bancamiga mercantil banplus banesco efectivo]

CATEGORIES = %w[comida transporte servicios ropa otros]

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
    account = Account.new(name: acct.capitalize, balance: 0, color: COLORS.sample)
    account.user = user
    account.save
    puts "cuentas creadas para #{user.email}:\n nombre: #{account.name}, balance: #{account.balance}"
  end

  puts "creando registros de la cuenta"

  hour = 0

  (DateTime.new(2024, 1, 1)..DateTime.now).to_a.each do |date|
    next if [true, false].sample
    (0..5).to_a.sample.times do
      record = Record.new(category: 0, note: "ejemplo")
      record.amount = (100..500).to_a.sample
      record.income = Random.rand(2) == 1
      record.account = user.accounts.sample
      record.result = record.account.balance + (record.income ? record.amount : -record.amount)
      record.category = CATEGORIES.sample
      record.created_at = DateTime.new(date.year, date.month, date.day, hour)
      if record.save
        record.account.balance += record.income ? record.amount : -record.amount
        record.account.save
        hour += 1
        hour = 0 if hour > 24
      end
    end
  end


end
