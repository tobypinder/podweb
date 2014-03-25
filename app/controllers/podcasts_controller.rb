class PodcastsController < ApplicationController

  require 'will_paginate/array'
  require 'feed_validator'

  before_filter :authenticate_user!, only: [ :create, :destroy ]
  before_filter :validate_podcast, only: [ :create ]

  def index
    @podcasts = Podcast.all.sort_by { |podcast| podcast.title.sub(/^(the|a|an)\s+/i, '') }.paginate(page: params[:page], per_page: 10)
  end

  def show
    @podcast = Podcast.find(params[:id])
    @episodes = @podcast.episodes.paginate(page: params[:page], per_page: 3)
  end

  def create
    podcast = Podcast.find_or_create_by(feed_url: params[:podcast][:feed_url])
    if podcast.save
      subscribe_to_podcast(podcast)
    else
      flash[:danger] = "There was an error finding or creating the Podcast."
      redirect_to current_user
    end
  end

  def update
    podcast = Podcast.find(params[:podcast][:id])
    subscribe_to_podcast(podcast)
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

    def subscribe_to_podcast(podcast)
      if current_user.podcasts << podcast
        flash[:success] = "Successfully subscribed."
      else
        flash[:danger] = "There was an error subscribing to the Podcast."
      end
      redirect_to current_user
    end
end
