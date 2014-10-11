class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :number
      t.string :type

      t.timestamps
    end
  end
end
