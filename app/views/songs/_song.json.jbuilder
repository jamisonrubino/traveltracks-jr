json.extract! song, :id, :id, :title, :artist, :album, :duration, :created_at, :updated_at
json.url song_url(song, format: :json)
