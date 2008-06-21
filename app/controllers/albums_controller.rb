class AlbumsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @album_pages, @albums = paginate :albums, :per_page => 10
  end

  def show
    @album = Album.find(params[:id])
  end

  def new
    @album = Album.new
  end

  def create
    @album = Album.new(params[:album])
    if @album.save
      flash[:notice] = 'Album was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(params[:album])
      flash[:notice] = 'Album was successfully updated.'
      redirect_to :action => 'show', :id => @album
    else
      render :action => 'edit'
    end
  end

  def destroy
    Album.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
