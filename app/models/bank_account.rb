class BankAccount < ActiveRecord::Base

  has_many :bank_entries

  validates_presence_of :number
  validates_presence_of :type
end
