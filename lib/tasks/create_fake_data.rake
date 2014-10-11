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
      amount: rand(-1470..1600),
      bank_account_id: BankAccount.all.map {|x| x.id }.sample,
      bank_date: rand(range),
    )
  end
  imports = BankEntry.all.map { |x| x.amount }.shuffle
  Invoice.fake_invoices(imports, range)

  BankAccount.all.each do |bank_account|
    bank_account.bank_entries.each_with_index do |entry, index|
      previous_account_amount = (bank_account.bank_entries[index-1].account_amount || 0)
      account_amount = previous_account_amount + entry.amount
      entry.update(account_amount: account_amount)
    end
  end
end
