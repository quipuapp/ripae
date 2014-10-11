class CreateBankEntries < ActiveRecord::Migration
  def change
    create_table :bank_entries do |t|
      t.string :concept
      t.decimal :amount
      t.integer :account_id
      t.date :bank_date
      t.integer :invoice_id
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
