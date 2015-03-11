class CatalogController < ApplicationController

  def index
    render json: {albums: Album.all}
  end

  def create
    Album.create(album_params)
    render json: {message: "success"}
  end

  private
  def album_params
    params.permit(:title, :artist, :thumb, :release_date, :price, :spotify_id, :condition)
  end

end
