class AddAccountAmountToBankEntries < ActiveRecord::Migration
  def up
    add_column :bank_entries, :account_amount, :decimal, precision: 15, scale: 4
  end

  def down

  end
end
