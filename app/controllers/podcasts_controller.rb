class PodcastsController < ApplicationController

  include PodcastsHelper
  require 'feed_validator'

  before_filter :authenticate_user!, only: [ :create, :destroy ]
  before_filter :validate_podcast, only: [ :create ]

  def index
    @podcasts = Podcast.all
  end

  def show
    @feed = get_feed(Podcast.find(params[:id]))
  end

  def create
    if podcast = Podcast.find_or_create_by(feed_url: params[:podcast][:feed_url])
      podcast.raw_feed = Feedjira::Feed.fetch_raw podcast.feed_url
      podcast.save
      current_user.podcasts << podcast
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

    def validate_podcast
      begin
        v = W3C::FeedValidator.new()
        if v.validate_url(params[:podcast][:feed_url])
          feed = Feedjira::Feed.fetch_and_parse(params[:podcast][:feed_url])
          if !defined? feed.title
            flash[:danger] = "Feed has no title, probably not valid."
            redirect_to current_user
          end
        else
          flash[:danger] = "Invalid Url."
          redirect_to current_user
        end
      rescue
        flash[:danger] = "Exception caught when trying to add Podcast."
        redirect_to current_user
      end
    end
end
