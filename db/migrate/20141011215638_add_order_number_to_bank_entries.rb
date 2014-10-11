class AddOrderNumberToBankEntries < ActiveRecord::Migration
  def change
    add_column :bank_entries, :order_number, :string
  end
end
