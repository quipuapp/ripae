class BankEntry < ActiveRecord::Base
  paginates_per 15

  belongs_to :bank_account
  belongs_to :invoice

  validates_presence_of :bank_account, :bank_date, :concept, :amount, :account_amount, :order_number
  validates_uniqueness_of :order_number

  scope :newest_first, lambda { order("bank_date DESC, id DESC") }
  scope :pending, lambda { where(arel_table[:invoice_id].eq(nil)) }
  scope :unmatched, lambda { where("bank_account_id is NOT NULL and bank_account_id != ''") }
  scope :inbounds, lambda { where("amount < 0") }
  scope :outbounds, lambda { where("amount >= 0") }

  def matched?
    invoice.present?
  end

  def unmatched?
    !matched?
  end

  def mark_as_read!
    self.read = true
    save
  end

  def assign_to_invoice!(invoice)
    self.invoice = invoice
    save
  end
end
