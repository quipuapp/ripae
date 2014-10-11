require 'rake'

Rake::Task.clear
Ripae::Application.load_tasks

class BankEntriesController < ApplicationController
  def index
    get_bank_entries
    get_first_bank_entry_data(@bank_entries.first)

    if params[:id] && @actual_bank_entry = BankEntry.find(params[:id])
      matched_id = params[:matched_id] || @actual_bank_entry.invoice_id

      mark_bank_entry_as_read
      get_current_matched_invoice(matched_id) if matched_id
      match_invoice(params, @actual_bank_entry) if matched_id && @actual_bank_entry.unmatched?
    end

    @proposed_invoices = proposed_invoices(params) if params &&
      params[:matched_id].nil? && (@actual_bank_entry.nil? || @actual_bank_entry.unmatched?)

    paginate_bank_entries!
  end

  def sync_with_api
    Rake::Task['sync_with_api'].invoke(session[:token])
    sleep(4)

    redirect_to bank_entries_path
  end

  private

  def proposed_invoices(params)
    Invoice.where(total_amount: params[:amount]).order("issue_date DESC")
  end

  def match_invoice(params, actual_bank_entry)
    actual_bank_entry.update(invoice_id: params[:matched_id])
  end

  def get_bank_entries
    return @bank_entries = BankEntry.all.order("bank_date DESC") if params.blank? || !params[:filter]
    @bank_entries = BankEntry.all.order("bank_date DESC") if params[:filter] == "all"
    @bank_entries = BankEntry.inbounds.order("bank_date DESC") if params[:filter] == "incomes"
    @bank_entries = BankEntry.outbounds.order("bank_date DESC") if params[:filter] == "outcomes"
  end

  def paginate_bank_entries!
    @page = params[:page] if params[:page]
    @bank_entries = @bank_entries.page(@page)
  end

  def get_current_matched_invoice(matched_id)
    @current_matched_invoice = Invoice.find(matched_id)
  end

  def mark_bank_entry_as_read
    BankEntry.find(params[:id]).update(read: true)
  end

  def get_first_bank_entry_data(bank_entry)
    return @proposed_invoices = Invoice.where(total_amount: bank_entry.amount).order("issue_date DESC") if bank_entry.unmatched?
    @current_matched_invoice = Invoice.find(bank_entry.invoice_id)
  end
end
