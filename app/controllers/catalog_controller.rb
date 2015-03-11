class CatalogController < ApplicationController

  def index
    render json: {albums: Album.all}
  end

  def create
    byebug
    p "HERE!"
    Album.create(album_params)
    "Success"
  end

  private
  def album_params
    params.permit(:title, :artist, :thumb, :release_date, :price, :spotify_id, :condition)
  end

end
