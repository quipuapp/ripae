require 'roo'

desc "sync bank entries from BancSabadell API"

task :sync_with_api, [:token] => [:environment] do |t, args|
  # Clean state
  Rake::Task['clean'].invoke

  # Import bank entries
  p args
  BancSabadell.api_key = args.token
  BancSabadell::Product.all.each do |product|
    if product.product == 'CC'
      bank_account = BankAccount.create(
        iban: product.iban,
        description: product.description,
        product_number: product.product_number
      )

      BancSabadell::AccountTransaction.all(
        product_number: bank_account.product_number,
        fechaDesde: '01-01-2014',
        fechaHasta: '01-01-2015'
      ).each do |account_transaction|
        BankEntry.create(
          bank_account: bank_account,
          bank_date: account_transaction.operation_date,
          concept: account_transaction.concept.capitalize,
          amount: account_transaction.amount.to_f,
          account_amount: account_transaction.accumulated_amount.to_f,
          order_number: account_transaction.order_number
        )
      end
    end
  end

  # Create invoices from file
  invoices_spreadsheet = Roo::Excelx.new(Rails.root.join('lib/tasks/fake_invoices.xlsx').to_s)
  invoices_spreadsheet.default_sheet = invoices_spreadsheet.sheets.first

  (invoices_spreadsheet.first_row + 1).upto(invoices_spreadsheet.last_row) do |row|
    amount = invoices_spreadsheet.cell(row, 3).to_f
    unitary_amount = amount / 1.21

    Invoice.create(
      concept: invoices_spreadsheet.cell(row, 1),
      contact_name: invoices_spreadsheet.cell(row, 2),
      unitary_amount: unitary_amount,
      quantity: 1,
      vat: 21,
      total_amount: amount,
      issue_date: invoices_spreadsheet.cell(row, 6)
    )
  end

  # End
  p [BankAccount.count, BankEntry.count, Invoice.count]
end
