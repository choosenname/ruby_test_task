class AddCategoryToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :category, null: false, foreign_key: true
  end
end
