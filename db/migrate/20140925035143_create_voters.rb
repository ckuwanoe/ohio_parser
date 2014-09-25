class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.string :state_voter_id
      t.integer :county_id
      t.string :county_name
      t.integer :county_voter_id
      t.date :av_requested_date
      t.date :av_sent_date
      t.date :av_returned_date
      t.date :ev_date
      t.timestamps
    end
  end
end
