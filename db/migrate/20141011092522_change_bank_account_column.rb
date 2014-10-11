class ChangeBankAccountColumn < ActiveRecord::Migration
  def up
    add_column :bank_accounts, :account_type, :string
  end

  def down
  end
end
