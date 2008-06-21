class OptionsController < ApplicationController
  layout 'index'

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @option_pages, @options = paginate :options, :per_page => 10
  end

  def show
    @option = Option.find(params[:id])
  end

  def new
    @option = Option.new
  end

  def create
    @option = Option.new(params[:option])
    if @option.save
      flash[:notice] = 'Option was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @option = Option.find(params[:id])
  end

  def update
    @option = Option.find(params[:id])
    if @option.update_attributes(params[:option])
      flash[:notice] = 'Option was successfully updated.'
      redirect_to :action => 'show', :id => @option
    else
      render :action => 'edit'
    end
  end

  def destroy
    Option.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
