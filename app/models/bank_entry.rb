class BankEntry < ActiveRecord::Base
  paginates_per 20

  belongs_to :bank_account
  belongs_to :invoice

  validates_presence_of :bank_account

  scope :unmatched, lambda { where("bank_account_id is NOT NULL and bank_account_id != ''") }
  scope :inbounds, lambda { where("amount < 0") }
  scope :outbounds, lambda { where("amount >= 0") }

  def matched?
    invoice_id.present?
  end

  def unmatched?
    !matched?
  end
end
