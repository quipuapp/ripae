desc "create fake data for Riape"

task :populate_fake_data => :environment do
  BankAccount.delete_all
  BankEntry.delete_all
  Invoice.delete_all
  range = Date.today-100..Date.today
  %w{ current card cash e-commerce }.each do |account_type|
    BankAccount.create(
      account_type: account_type,
      number: Faker::Code.ean
    )
  end
  600.times do
    BankEntry.create(
      concept: Faker::App.name,
      amount: rand(25..1600),
      bank_account_id: BankAccount.all.map {|x| x.id }.sample,
      bank_date: rand(range)
    )
  end
  imports = BankEntry.all.map { |x| x.amount }.shuffle[0..149]
  Invoice.fake_invoices(imports, range)
end
