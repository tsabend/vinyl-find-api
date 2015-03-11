class AlbumSearchController < ApplicationController

  def test
    "hello"

  end

  def find
    image_file = params[:file].tempfile
    image_name = Time.now.to_s + ".jpeg"
    # Upload image
    $s3.objects.create(image_name, image_file)
    # # Run search
    image_url = "https://s3-us-west-2.amazonaws.com/#{ENV['S3_BUCKET']}/#{image_name}"
    res = Blockspring.runParsed("5a1b66ef208007c51a45fda220dbe8db", {image_url: image_url})
    best_search = res.params["best_search"]
    p best_search
    album_search = $Discogs.search(best_search, :per_page => 10, :type => :album)
    album = album_search.results.first
    price = DiscogsMarketplace.price(album.id)

    spotify_search = $Spotify.search("album", best_search)
    spotify_album_id = spotify_search["albums"]["items"].first["id"]
    spotify_album = $Spotify.album(spotify_album_id)

    song_previews = spotify_album["tracks"]["items"].map do |item|
      {
        "name": item["name"],
        "preview_url": item["preview_url"],
        "duration_ms": item["duration_ms"]
      }
    end

    title = spotify_search["albums"]["items"].first["name"]
    artist = spotify_album["artists"][0]["name"]
    thumb = spotify_album["images"][1]["url"]
    release_date = spotify_album["release_date"]
    album_object = {
      "title": title,
      "artist": artist,
      "release_date": release_date,
      "thumb": thumb,
      "spotify_id": spotify_album_id,
      "song_previews": song_previews,
      "price": price.to_s # easier to deal with type conversions on the other side
    }
    p album_object
    # format html =>
    # format json =>


    render json: album_object
  end

  def show
    best_search = params[:best_search]
    @album = album_search.results.first
  end

  private
  def find_params
    params.permit("file")
  end

end
