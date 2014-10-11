class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :concept
      t.string :target_name
      t.string :origin_name
      t.decimal :unitary_amount
      t.integer :quantity
      t.decimal :total_amount
      t.decimal :vat
      t.date :issue_date
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
