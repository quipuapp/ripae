class BankAccount < ActiveRecord::Base
  has_many :bank_entries

  validates_presence_of :iban, :description, :product_number

  def name
    "#{description} (#{iban})"
  end
end
