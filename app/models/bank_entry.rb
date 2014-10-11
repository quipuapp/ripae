class BankEntry < ActiveRecord::Base

  belongs_to :bank_account
  belong_to :invoice

  validates_presence_of :account_id
  validates_presence_of :invoice_id
end
