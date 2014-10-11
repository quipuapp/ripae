class ChangeAccountIdOnBankEntries < ActiveRecord::Migration
  def change
    rename_column :bank_entries, :account_id, :bank_account_id
  end
end
