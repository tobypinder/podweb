class PodcastsController < ApplicationController

  require 'feed_validator'

  before_filter :authenticate_user!

  def show
    @podcast = Feedjira::Feed.fetch_and_parse(Podcast.find(params[:id]).feed_url)
  end

  def create
    begin
      v = W3C::FeedValidator.new()
      if v.validate_url(params[:podcast][:feed_url]) && v.valid?
        if current_user.podcasts << Podcast.find_or_create_by(feed_url: params[:podcast][:feed_url])
          flash[:success] = "Successfully Subscribed."
        else
          flash[:danger] = "There was an Error."
        end
      end
    rescue
      flash[:danger] = "Invalid Url for Feed."
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
