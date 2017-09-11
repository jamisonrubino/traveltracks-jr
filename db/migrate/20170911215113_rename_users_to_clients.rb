class RenameUsersToClients < ActiveRecord::Migration[5.1]
  def change
    rename_table :users, :clients
  end
end
