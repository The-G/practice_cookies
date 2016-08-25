class AddDeleteCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :delete_count, :integer, default: 0
  end
end
