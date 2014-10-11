class BankEntry < ActiveRecord::Base

  belongs_to :bank_account
  belongs_to :invoice

  validates_presence_of :bank_account_id
end
