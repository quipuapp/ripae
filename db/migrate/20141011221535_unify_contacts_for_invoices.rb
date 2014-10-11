class UnifyContactsForInvoices < ActiveRecord::Migration
  def up
    add_column :invoices, :contact_name, :string
    remove_column :invoices, :target_name
    remove_column :invoices, :origin_name
  end

  def down
    add_column :invoices, :origin_name, :string
    add_column :invoices, :target_name, :string
    remove_column :invoices, :contact_name
  end
end
