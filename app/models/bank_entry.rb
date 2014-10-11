class BankEntry < ActiveRecord::Base

  belongs_to :bank_account
  belongs_to :invoice

  validates_presence_of :bank_account_id

  scope :unmatched, lambda { where("bank_account_id is NOT NULL and bank_account_id != ''") }
end
