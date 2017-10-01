class AddPlaylistIdToPlaylists < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :playlist_id, :string
  end
end
