# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141011103125) do

  create_table "bank_accounts", force: true do |t|
    t.string   "number"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_type"
  end

  create_table "bank_entries", force: true do |t|
    t.string   "concept"
    t.decimal  "amount",          precision: 25, scale: 4
    t.integer  "bank_account_id"
    t.date     "bank_date"
    t.integer  "invoice_id"
    t.boolean  "read",                                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "account_amount",  precision: 15, scale: 4
  end

  create_table "invoices", force: true do |t|
    t.string   "concept"
    t.string   "target_name"
    t.string   "origin_name"
    t.decimal  "unitary_amount", precision: 15, scale: 4
    t.integer  "quantity"
    t.decimal  "total_amount",   precision: 15, scale: 4
    t.decimal  "vat",            precision: 15, scale: 4
    t.date     "issue_date"
    t.boolean  "read",                                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
