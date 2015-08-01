class AddDeletedAtToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :deleted_at, :datetime
    add_index :authors, :deleted_at
  end
end
