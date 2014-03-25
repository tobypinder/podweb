class HomeController < ApplicationController

  require 'will_paginate/array'

  def index
    if user_signed_in?
      episode_list = []
      current_user.podcasts.each do |podcast|
        podcast.episodes.each do |episode|
          episode_list << episode
        end
      end

      episode_list = episode_list.sort_by { |episode| episode.published }
      @episode_list_by_day = episode_list.group_by { |episode| episode.published.strftime("%B #{episode.published.day.ordinalize}, %Y") }
      @episode_list_by_day = @episode_list_by_day.sort_by { |date, episode_list| [Date.parse(date).year, Date.parse(date).month, Date.parse(date).day] }.reverse.paginate(page: params[:page], per_page: 2)
    end
  end
end