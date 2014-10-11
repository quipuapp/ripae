class Invoice < ActiveRecord::Base
  has_one :bank_entry

  validates_presence_of :concept, :contact_name, :unitary_amount,
    :quantity, :vat

  USER_NAME = "Rust Cohle"

  class << self
    def fake_invoices(prices, range)
      3.times do
        prices.each do |price|
          t=[{a: true}, {b: true}].sample
          origin_name, target_name=USER_NAME, Faker::Name.name if t[:a].present?
          origin_name, target_name=Faker::Name.name, USER_NAME if t[:b].present?
          quantity = rand(1..1000)
          unitary_amount = (price.fdiv(quantity)).fdiv(1.21)
          create(
            origin_name: origin_name,
            target_name: target_name,
            concept: Faker::Commerce.product_name,
            unitary_amount: unitary_amount,
            quantity: quantity,
            total_amount: price,
            issue_date: rand(range),
            vat: 21
          )
        end
      end
    end
  end
end
