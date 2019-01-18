class ChangeDatatypeDescriptionOfTopics < ActiveRecord::Migration[5.2]
  def change
    change_column :topics, :description, :text
  end
end
