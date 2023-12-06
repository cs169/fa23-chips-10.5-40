# frozen_string_literal: true

class CreateCampaignFinances < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_finances do |t|
      t.string :first_name
      t.string :last_name
      t.decimal :candidate_loans
      t.decimal :total_contributions
      t.decimal :debts_owed
      t.decimal :total_disbursements
      t.decimal :end_cash
      t.decimal :total_from_individuals
      t.decimal :total_from_pacs
      t.decimal :total_refunds
      t.timestamps null: false
    end
  end
end
