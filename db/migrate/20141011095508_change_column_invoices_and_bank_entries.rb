class ChangeColumnInvoicesAndBankEntries < ActiveRecord::Migration
  def change
    change_column :invoices, :unitary_amount, :decimal, precision: 15, scale: 4
    change_column :invoices, :total_amount, :decimal, precision: 15, scale: 4
    change_column :invoices, :vat, :decimal, precision: 15, scale: 4
    change_column :bank_entries, :amount, :decimal, precision: 25, scale: 4
  end
end
