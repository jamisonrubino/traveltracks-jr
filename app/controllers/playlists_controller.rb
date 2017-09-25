require 'json'

class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]


  # GET /playlists
  # GET /playlists.json
  def index
    spotify_user = RSpotify::User.new(session['spotify_user'])
    @playlists = Playlist.where(user_id: session['spotify_user_id'])
  end

  # GET /playlists/1
  # GET /playlists/1.json
  def show
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists
  # POST /playlists.json
  def create
    spotify_user = RSpotify::User.new(session['spotify_user'])
    
    playlist_time = set_time
    playlist_pool = set_pool(spotify_user)
    pt = organize_tracks(playlist_time, playlist_pool)
    playlist = make_playlist(spotify_user)
    add_tracks(pt, playlist)
    
    @playlist = Playlist.new
    @playlist.uri = playlist.uri
    @playlist.title = playlist.name
    @playlist.user_id = session['spotify_user_id']
    
    if @playlist.save
      flash[:notice] = "Your playlist was successfully created."
      redirect_to "/playlists/#{@playlist.id}"
    end
    
  end

  # PATCH/PUT /playlists/1
  # PATCH/PUT /playlists/1.json
  
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1
  # DELETE /playlists/1.json
  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: 'Playlist was successfully destroyed.' }
      format.json { head :no_content }
    end
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
        start = params[:directions][:start]
        destination = params[:directions][:destination]
        directions = GoogleDirections.new(start, destination)
        unless directions.status == ("NOT_FOUND" || "OVER_QUERY_LIMIT")
          playlist_time = directions.drive_time_in_minutes
        end
        
      # if user manually enters time
      elsif params[:time][:hours].size > 0 || params[:time][:minutes].size > 0
        hours = params[:time][:hours].to_i ||= 0
        minutes = params[:time][:minutes].to_i ||= 0
        playlist_time = hours * 60 + minutes
      else
        playlist_time = 0
        flash[:notice] = "There was an error with your playlist time. Double-check your input before resubmitting."
        redirect_to root_path
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
        genres = []
        genre_options = [params[:genre_seed_one], params[:genre_seed_two], params[:genre_seed_three]]
        genre_options.each do |opt|
          unless opt == ""
            genres << opt
          end
        end
        if genres.size == 1
          genres = genres[0].to_s
        end
        recs = RSpotify::Recommendations.generate(seed_genres: genres, limit: 100)
        playlist_pool = []
        recs.tracks.each do |track|
          playlist_pool << track
        end
        puts playlist_pool
      elsif params[:pool] == "saved_tracks"
        puts "my_saved_tracks if branch"
        playlist_pool_1 = spotify_user.saved_tracks(limit: 50, offset: 0)
        playlist_pool_2 = spotify_user.saved_tracks(limit: 50, offset: 50)
        playlist_pool_3 = spotify_user.saved_tracks(limit: 50, offset: 100)
        playlist_pool_4 = spotify_user.saved_tracks(limit: 50, offset: 150)
        
        playlist_pool = []
        playlist_pool += playlist_pool_1 + playlist_pool_2 + playlist_pool_3 + playlist_pool_4
        
      elsif params[:pool] == "top_tracks"
        playlist_pool_1 = spotify_user.top_tracks(time_range: 'long_term', limit: 50, offset: 0)
        playlist_pool_2 = spotify_user.top_tracks(time_range: 'long_term', limit: 50, offset: 50)
        playlist_pool_3 = spotify_user.top_tracks(time_range: 'long_term', limit: 50, offset: 100)
        playlist_pool_4 = spotify_user.top_tracks(time_range: 'long_term', limit: 50, offset: 150)
        
        playlist_pool = []
        playlist_pool += playlist_pool_1 + playlist_pool_2 + playlist_pool_3 + playlist_pool_4

      elsif params[:pool] == "artist"
        puts "params[:seed][:artist]: #{params[:seed][:artist]}"
        artists = RSpotify::Artist.search(params[:seed][:artist], limit: 10, market: {from: spotify_user})
        artist = artists.first
        recs = RSpotify::Recommendations.generate(seed_artists: [artist.id], limit: 100)
        playlist_pool = []
        recs.tracks.each do |track|
          playlist_pool << track
        end
      end
      
      playlist_pool
    end
    
    
    def organize_tracks(playlist_time, playlist_pool)
      # TO-DO: CREATE POOL LENGTH VARIABLE, CHECK AGAINST TRIP LENGTH; SUGGEST SAVING TRACKS OR ADDING GENRE SEEDS IF POOL LENGTH IS SHORTER
      # RANDOMLY ADD TO PT (PLAYLIST TRACKS) ARRAY UNLESS IT WOULD EXCEED PLAYLIST_TIME
      pt = []
      ps = playlist_pool.size
      puts "playlist pool size: #{ps}"
      ptime = 0.000
      until (playlist_time - ptime).abs.round(2) <= 2.00
        if playlist_pool.size > 1
          rn = Random.rand(playlist_pool.size-1)
          unless ptime + playlist_pool[rn].duration_ms/60000.000 > playlist_time+2.00
            pt << playlist_pool[rn]
            playlist_pool.delete_at(rn)
            ptime += playlist_pool[rn].duration_ms/60000.000
            puts "ptime: #{ptime}"
          end
        else
          flash[:notice] = "Failure building playlist pool. Try saving more tracks or selecting different genres."
          redirect_to root_path
        end
      end
    
      puts "playlist_time: #{playlist_time}"
      puts "ptime: #{ptime}"
      puts pt.size
      
      if playlist_time - ptime > 6
        flash[:alert] = "Your playlist pool was shorter than your trip time. Try using genre seeds or saving more Spotify tracks to your library."
      end
      
      pt
    end


    def make_playlist(spotify_user)
      # CREATING NEW PLAYLIST
      playlist_name = "My Roadtrip Playlist"
      playlist_name += " #{params[:directions][:start]} to #{params[:directions][:destination]}" if params[:directions][:start].size > 0 && params[:directions][:destination].size > 0
      
      puts "Creating playlist!"
      playlist = spotify_user.create_playlist!(playlist_name)
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
