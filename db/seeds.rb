Account.destroy_all
Plan.destroy_all
Fixed.destroy_all

COLORS = %w[#8C656C #7E8691 #BF978E #D9BBB4 #8BBF95
            #141A26 #735774 #808C65 #40272B #D99191
            #D97904 #4A5914 #3676A8 #048ABF #8298D9]

ACCOUNTS = ["zinli", "mercantil", "efectivo", "mercantil panamá", "provincial"]

CATEGORIES = %w[Comida Compras Trabajo Educación Vivienda Transporte Salud Entretenimiento Comunicaciones Inversiones Otros]

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

  user.accounts[1].records.create(category: "Otros", amount: 18400, result: 18400, income: true, created_at: DateTime.new(2024, 1, 1), note: "Pago mensual")
  user.accounts[1].records.create(category: "Otros", amount: 18400, result: 18400, income: true, created_at: DateTime.new(2024, 2, 1), note: "Pago mensual")
  user.accounts[1].records.create(category: "Otros", amount: 18400, result: 18400, income: true, created_at: DateTime.new(2024, 3, 1), note: "Pago mensual")

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
