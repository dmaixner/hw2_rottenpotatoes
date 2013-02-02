class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    def get_param(name)
      p=params[name]
      if p
        session[name]=p
      else
        p=session[name]
      end
      p
    end

    redirect_params=Hash.new
    redirect_params[:ratings] = get_param(:ratings)
    redirect_params[:order] = get_param(:order)
    if ((!params[:order] && redirect_params[:order]) || (!params[:ratings] && redirect_params[:ratings]))
      flash.keep
      redirect_to movies_path redirect_params
    end

    @title_class={:class=>if redirect_params[:order]=="title" then "hilite" end}
    @date_class={:class=>if redirect_params[:order]=="release_date" then "hilite" end}
    @ratings=redirect_params[:ratings]
    @movies = Movie.where(@ratings ? {:rating=>@ratings.keys} : nil).all(:order=>params[:order])
    @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
