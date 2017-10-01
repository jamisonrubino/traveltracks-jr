require 'json'
require 'httparty'

class PlaylistsController < ApplicationController
  include HTTParty
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]


  # GET /playlists
  # GET /playlists.json
  def index
    spotify_user = RSpotify::User.new(session['spotify_user'])
    @playlists = Playlist.where(user_id: session['spotify_user_id']).sort { |x,y| y.id <=> x.id }
  end


  def show

  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # POST /playlists
  # POST /playlists.json
  def create
    spotify_user = RSpotify::User.new(session['spotify_user'])
    playlist_time = set_time
    playlist_pool = set_pool(spotify_user)
  
    flash[:alert] = "Enter your playlist time and music source." if playlist_pool.nil? && playlist_time == 0
    
    unless flash[:alert]
      pt = organize_tracks(playlist_time, playlist_pool)
      unless flash[:alert]
        playlist = make_playlist(spotify_user)
        add_tracks(pt, playlist)
        
        @playlist = Playlist.new
        @playlist.uri = playlist.uri
        @playlist.title = playlist.name
        @playlist.user_id = session['spotify_user_id']

        if @playlist.save
          flash[:notice] = "Your playlist was successfully created."
          redirect_to "/playlists/#{@playlist.id}"
        else
          flash[:alert] = "We had trouble saving your playlist to our database. Please check your Spotify library."
        end
    
      else
        redirect_to root_path
        return
      end
    else
      redirect_to root_path
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist = Playlist.find(params[:id])
    if @playlist.destroy
      flash[:notice] = "Your playlist was successfully deleted."
    else
      flash[:alert] = "Something went wrong."
    end
    redirect_to playlists_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def playlist_params
    #   params.fetch(:playlist, {})
    # end
    
        
    def set_time
      if params[:directions][:start].size > 0 && params[:directions][:destination].size > 0
        
        values = {
          origin: params[:directions][:start],
          destination: params[:directions][:destination],
          mode: "driving",
          key: ENV['GOOGLE_MAPS_API_KEY']
        }
        
        url = "https://maps.googleapis.com/maps/api/directions/json?" + values.to_query
        
        puts url
        response = self.class.get url
        
        directions = JSON.parse(response.body)
        playlist_time = directions['routes'].first['legs'].first['duration']['value'].to_i / 60.00
        
      # if user manually enters time
      elsif params[:time][:hours].size > 0 || params[:time][:minutes].size > 0
        hours = params[:time][:hours].to_i ||= 0
        minutes = params[:time][:minutes].to_i ||= 0
        playlist_time = hours * 60 + minutes
        if playlist_time == 0
          flash[:alert] = "You forgot the length of your playlist."
        end
      else
        playlist_time = 0
        flash[:alert] = "There was an error with your playlist time."
      end
    
      # if trip is longer than six hours
      if playlist_time > 360
        playlist_time = 360
      end
      
      playlist_time
    end
    
    
    
    def set_pool(spotify_user)
      # SETTING POOL OF TRACKS FOR NEW PLAYLIST
      if params[:pool] == "genre"
        unless params[:genre_seed_one].size == 0 && params[:genre_seed_two].size == 0 && params[:genre_seed_three].size == 0
          genres = []
          genre_options = [params[:genre_seed_one], params[:genre_seed_two], params[:genre_seed_three]]
          genre_options.each do |opt|
            unless opt == ""
              genres << opt
            end
          end
          recs = RSpotify::Recommendations.generate(seed_genres: genres, limit: 100)
          playlist_pool = []
          recs.tracks.each do |track|
            playlist_pool << track
          end
          puts playlist_pool
        else
          flash[:alert] = "Please enter genre seeds."
        end
      elsif params[:pool] == "saved_tracks"
        puts "my_saved_tracks if branch"
        playlist_pool_1 = spotify_user.saved_tracks(limit: 50, offset: 0)
        playlist_pool_2 = spotify_user.saved_tracks(limit: 50, offset: 50)
        playlist_pool_3 = spotify_user.saved_tracks(limit: 50, offset: 100)
        playlist_pool_4 = spotify_user.saved_tracks(limit: 50, offset: 150)
        playlist_pool_5 = spotify_user.saved_tracks(limit: 50, offset: 200)
        playlist_pool_6 = spotify_user.saved_tracks(limit: 50, offset: 250)
        
        playlist_pool = []
        playlist_pool += playlist_pool_1 + playlist_pool_2 + playlist_pool_3 + playlist_pool_4 + playlist_pool_5 + playlist_pool_6
        
      elsif params[:pool] == "top_tracks"
        playlist_pool_1 = spotify_user.top_tracks(time_range: 'medium_term', limit: 50, offset: 0)
        # playlist_pool_2 = spotify_user.top_tracks(time_range: 'long_term', limit: 50, offset: 50)
        # playlist_pool_3 = spotify_user.top_tracks(time_range: 'long_term', limit: 50, offset: 100)
        # playlist_pool_4 = spotify_user.top_tracks(time_range: 'long_term', limit: 50, offset: 150)
        
        playlist_pool = []
        playlist_pool += playlist_pool_1
        # + playlist_pool_2 + playlist_pool_3 + playlist_pool_4

      elsif params[:pool] == "artist"
        puts "params[:seed][:artist]: #{params[:seed][:artist]}"
        unless params[:seed][:artist].size == 0
          artists = RSpotify::Artist.search(params[:seed][:artist], limit: 10, market: {from: spotify_user})
          artist = artists.first
          if !artist.nil?
            recs = RSpotify::Recommendations.generate(seed_artists: [artist.id], limit: 100)
            playlist_pool = []
            recs.tracks.each do |track|
              playlist_pool << track
            end
            params[:seed][:artist] = artist.name
          else
            playlist_pool = "error"
            flash[:alert] = "Artist not found."
          end
        else
          flash[:alert] = "Please enter an artist."
          playlist_pool = []
        end
      end
      
      if playlist_pool.nil?
        flash[:alert] = "Select your playlist music source."
      end
      
      playlist_pool
    end
    
    
    def organize_tracks(playlist_time, playlist_pool)
      # TO-DO: CREATE POOL LENGTH VARIABLE, CHECK AGAINST TRIP LENGTH; SUGGEST SAVING TRACKS OR ADDING GENRE SEEDS IF POOL LENGTH IS SHORTER
      # RANDOMLY ADD TO PT (PLAYLIST TRACKS) ARRAY UNLESS IT WOULD EXCEED PLAYLIST_TIME
      pt = []
      ps = playlist_pool.size
      puts "playlist pool size: #{ps}"
      puts "playlist_time: #{playlist_time}"
      ptime = 0.000
      until (playlist_time - ptime).abs.round(2) <= 2.00
        if playlist_pool.size > 1
          rn = Random.rand(playlist_pool.size-1)
          unless ptime + playlist_pool[rn].duration_ms/60000.000 > playlist_time + 2.00
            pt << playlist_pool[rn]
            ptime += playlist_pool[rn].duration_ms/60000.000
            puts "ptime: #{ptime}"
          end
          playlist_pool.delete_at(rn)
        end
      end
    
      puts "playlist_time: #{playlist_time}"
      puts "ptime: #{ptime}"
      puts pt.size
      
      if playlist_time - ptime > 6
        flash[:alert] = "Your tracks pool was shorter than your trip time. Try using genre seeds or saving more Spotify tracks to your library."
      end
      
      pt
    end


    def make_playlist(spotify_user)
      # CREATING NEW PLAYLIST
      playlist_name = "Roadtrip Playlist"
      
      if params[:directions][:start].size > 0 && params[:directions][:destination].size > 0
        if params[:directions][:start].count(',') > 1
          start_arr = params[:directions][:start].split(',')
          start = start_arr[0..1].join(',')
        end
        if params[:directions][:destination].count(',') > 1
          destination_arr = params[:directions][:destination].split(',')
          destination = destination_arr.take(2).join(',')
        end
        
        playlist_name += ", #{start} to #{destination}"
      end
      
      playlist_name += ", my top tracks" if params[:pool] == "top_tracks"
      
      playlist_name += ", my saved tracks" if params[:pool] == "saved_tracks"
      
      playlist_name += ", #{params[:genre_seed_one]}" if params[:pool] == "genre" && params[:genre_seed_one].size > 0
      playlist_name += ", #{params[:genre_seed_two]}" if params[:pool] == "genre" && params[:genre_seed_two].size > 0
      playlist_name += ", #{params[:genre_seed_three]}" if params[:pool] == "genre" && params[:genre_seed_three].size > 0
      
      playlist_name += ", #{params[:seed][:artist]}" if params[:seed][:artist].size > 0
      
      puts "Creating playlist!"
      playlist = spotify_user.create_playlist!(playlist_name)
      playlist.change_details!(public: false)
      playlist
    end
    
    
    def add_tracks(pt, playlist)
      puts "Adding tracks!"
      n = (pt.size/10.0).ceil
  
      a = []
      n.times do |i|
        a[i] = []
        if i == n-1     # if it's the only set
          puts "#{pt.size%10} times"
          pt.size%10.times do |v|
            a[i] << pt[i*10 + v] if pt[i*10 + v]
          end
        else
          puts "10 times"
          10.times do |v|
            a[i] << pt[i*10 + v] if pt[i*10 + v]
          end
        end
        playlist.add_tracks!(a[i])
      end
      puts a
    end
end
