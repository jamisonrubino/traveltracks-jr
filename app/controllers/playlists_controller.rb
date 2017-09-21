require 'json'

class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]

  # GET /playlists
  # GET /playlists.json
  def index
    @playlists = session['spotify_user'].user_playlists(:id).pluck(:name)
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
    # if user specifies starting point and destination
    spotify_user = RSpotify::User.new(session['spotify_user'])
    
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
      playlist_pool = RSpotify::Recommendations.generate(seed_genres: genres, limit:100) #
    elsif params[:pool] == "top_tracks"
      puts "my_top_tracks if branch"
      playlist_pool_1 = spotify_user.saved_tracks(limit: 50, offset: 0)
      playlist_pool_2 = spotify_user.saved_tracks(limit: 50, offset: 50)
      playlist_pool_3 = spotify_user.saved_tracks(limit: 50, offset: 100)
      playlist_pool_4 = spotify_user.saved_tracks(limit: 50, offset: 150)
      
      playlist_pool = []
      playlist_pool += playlist_pool_1 + playlist_pool_2 + playlist_pool_3 + playlist_pool_4
    end
    
    pt = []
    ps = playlist_pool.size
    ptime = 0
    ps.times do
      rn = Random.rand(ps-1)
      unless ptime + playlist_pool[rn].duration_ms/60000.round(2) >= playlist_time
        pt << playlist_pool[rn]
        playlist_pool.delete_at(rn)
        ptime += playlist_pool[rn].duration_ms/60000.round(2)
      end
    end
    
    ps = playlist_pool.size
    ltt = playlist_time - ptime
    playlist_pool.map {|t| pt << t if ltt - t.duration_ms/60000.round(2).abs < 1.5 }
    
      
    if playlist_time - ptime > 6
      flash[:notice] = "Your playlist pool was shorter than your trip time. Try using genre seeds or saving more Spotify tracks to your library."
    end

    # CREATING NEW PLAYLIST
    playlist_name = "My Roadtrip Playlist"
    playlist_name += " #{params[:directions][:start] if params[:directions][:start]} to #{params[:directions][:destination] if params[:directions][:destination]}" if params[:pool] = params[:directions][:start].size > 0 && params[:directions][:destination].size > 0
    
    playlist = spotify_user.create_playlist!(pt)
    
    
    
    # ADDING SELECTED TRACKS TO NEW PLAYLIST
    # playlist.add_tracks!(recommendations.tracks)
    
    puts "params[:pool]: #{params[:pool]}"
    puts "Playlist time: #{playlist_time}"
    puts "Playlist pool: #{playlist_pool}"
    puts "Refined playlist pool: #{pps}"
    
    redirect_to root_path
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
    def playlist_params
      params.fetch(:playlist, {})
    end
end
