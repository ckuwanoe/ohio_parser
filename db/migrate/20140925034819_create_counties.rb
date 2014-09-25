class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
      t.string :url
      t.boolean :standard
      t.timestamps
    end
  end
end
