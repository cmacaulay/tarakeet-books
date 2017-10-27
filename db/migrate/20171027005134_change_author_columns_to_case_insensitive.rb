class ChangeAuthorColumnsToCaseInsensitive < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'citext'

    change_column :authors, :first_name, :citext
    change_column :authors, :last_name, :citext
  end
end
