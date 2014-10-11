class BankEntriesController < ApplicationController
  def index
    actual_bank_entry = BankEntry.find(params[:id])
    @bank_entries = BankEntry.all.order("bank_date DESC")
    @proposed_invoices = proposed_invoices(params) if params && params[:matched_id].nil?
    @current_matched_invoice = Invoice.find(params[:matched_id]) if params[:matched_id]
  end

  def proposed_invoices(params)
    Invoice.where(total_amount: params[:amount]).order("issue_date DESC")
  end
end
