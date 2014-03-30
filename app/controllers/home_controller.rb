class HomeController < ApplicationController

  require 'will_paginate/array'

  def index
    if user_signed_in?
      @episode_list = []
      current_user.podcasts.each do |podcast|
        podcast.episodes.each do |episode|
          @episode_list << episode
        end
      end

      @episode_list = @episode_list.sort_by { |episode| episode.publish_date }.reverse.paginate(page: params[:page], per_page: 10)
    end
  end
end