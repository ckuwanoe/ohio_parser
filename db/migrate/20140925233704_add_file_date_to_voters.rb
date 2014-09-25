class AddFileDateToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :file_date, :date
  end
end
