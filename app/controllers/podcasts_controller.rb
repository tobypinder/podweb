class PodcastsController < ApplicationController

  before_filter :authenticate_user!

  def create
    if current_user.podcasts << Podcast.find_or_create_by(feed_url: params[:podcast][:feed_url])
      flash[:success] = "Successfully Subscribed."
    else
      flash[:danger] = "There was an Error."
    end
    redirect_to current_user
  end

  def destroy
    current_user.podcasts.delete(Podcast.find(params[:id]))
    redirect_to current_user
  end

  private

    def podcast_params
      params.require(:podcast).permit(:feed_url)
    end
end
