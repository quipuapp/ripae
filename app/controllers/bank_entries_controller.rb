require 'rake'

Rake::Task.clear
Ripae::Application.load_tasks

class BankEntriesController < ApplicationController
  def index
    load_bank_account
    load_and_sort_bank_entries
    filter_bank_entries

    load_featured_bank_entry
    load_related_invoices
    match_invoice_to_bank_entry
  end

  def sync_with_api
    Rake::Task['clean'].invoke
    Rake::Task['sync_with_api'].invoke(session[:token])
    sleep(7)

    redirect_to bank_entries_path
  end

  private

  def load_bank_account
    @current_bank_account = BankAccount.find_by(id: params[:bank_account_id]) || BankAccount.first
    @other_bank_accounts = BankAccount.all - [@current_bank_account]
  end

  def load_and_sort_bank_entries
    @bank_entries = @current_bank_account.bank_entries.newest_first
    @most_recent_bank_entry = @bank_entries.first
  end

  def filter_bank_entries
    @current_filter = params[:filter] || "all"
    @bank_entries = @bank_entries.incomes if params[:filter] == 'incomes'
    @bank_entries = @bank_entries.outcomes if params[:filter] == 'outcomes'
    @bank_entries = @bank_entries.pending if params[:filter] == 'pending'
  end

  def load_featured_bank_entry
    if @featured_bank_entry = @bank_entries.find_by(id: params[:selected_bank_entry_id]) || @bank_entries.first
      @featured_bank_entry.mark_as_read!
    end
  end

  def load_related_invoices
    return unless @featured_bank_entry.present?

    if @featured_bank_entry.matched?
      @current_matched_invoice = @featured_bank_entry.invoice
    else
      @related_invoices = Invoice.where(total_amount: @featured_bank_entry.amount).select(&:unmatched?)
    end
  end

  def match_invoice_to_bank_entry
    if @featured_bank_entry.present? && invoice = Invoice.find_by(id: params[:matched_invoice_id])
      @featured_bank_entry.assign_to_invoice!(invoice)
    end
  end
end
