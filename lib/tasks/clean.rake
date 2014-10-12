desc "clean all data"

task :clean => :environment do
  BankEntry.delete_all
  BankAccount.delete_all
  Invoice.delete_all
end
