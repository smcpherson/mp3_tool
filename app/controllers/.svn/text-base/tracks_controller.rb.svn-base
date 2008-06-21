class TracksController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @track_pages, @tracks = paginate :tracks, :per_page => 10
  end

  def show
    @track = Track.find(params[:id])
  end

  def new
    @track = Track.new
  end

  def create
    @track = Track.new(params[:track])
    if @track.save
      flash[:notice] = 'Track was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @track = Track.find(params[:id])
  end

  def update
    @track = Track.find(params[:id])
    if @track.update_attributes(params[:track])
      flash[:notice] = 'Track was successfully updated.'
      redirect_to :action => 'show', :id => @track
    else
      render :action => 'edit'
    end
  end

  def destroy
    Track.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
