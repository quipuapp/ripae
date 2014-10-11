class BankEntriesController < ApplicationController
  def index

    get_bank_entries(params)

    if params[:id] && actual_bank_entry = BankEntry.find(params[:id])
      matched_id = params[:matched_id] ? params[:matched_id] : actual_bank_entry.invoice_id
      @current_matched_invoice = Invoice.find(matched_id) if matched_id
      match_invoice(params, actual_bank_entry) if matched_id &&
        actual_bank_entry.unmatched?
    end

    @proposed_invoices = proposed_invoices(params) if params &&
      params[:matched_id].nil? && (actual_bank_entry.nil? || actual_bank_entry.unmatched?)
  end

  def proposed_invoices(params)
    Invoice.where(total_amount: params[:amount]).order("issue_date DESC")
  end

  def match_invoice(params, actual_bank_entry)
    actual_bank_entry.update(invoice_id: params[:matched_id])
  end

  def get_bank_entries(params={})
    return @bank_entries = BankEntry.all.order("bank_date DESC") if params.blank? || !params[:filter]
    @bank_entries = BankEntry.all.order("bank_date DESC") if params[:filter] == "all"
    @bank_entries = BankEntry.inbounds.order("bank_date DESC") if params[:filter] == "incomes"
    @bank_entries = BankEntry.outbounds.order("bank_date DESC") if params[:filter] == "outcomes"
  end
end
