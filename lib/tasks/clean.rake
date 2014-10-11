desc "clean all data"

task :clean => :environment do
  BankAccount.delete_all
  BankEntry.delete_all
  Invoice.delete_all
end
