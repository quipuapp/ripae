class UpdateBankAccounts < ActiveRecord::Migration
  def change
    rename_column :bank_accounts, :number, :iban
    add_column :bank_accounts, :description, :string
    add_column :bank_accounts, :product_number, :string
  end
end
