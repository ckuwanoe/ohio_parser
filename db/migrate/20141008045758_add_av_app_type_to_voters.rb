class AddAvAppTypeToVoters < ActiveRecord::Migration
  def change
    add_column :voters, :av_app_type, :string
  end
end
