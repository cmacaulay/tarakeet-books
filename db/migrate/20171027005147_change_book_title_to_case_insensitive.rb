class ChangeBookTitleToCaseInsensitive < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'citext'

    change_column :books, :title, :citext
  end
end
