class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :title
      t.string :user_id
      t.string :uri
      t.datetime :created_at

      t.timestamps
    end
  end
end
