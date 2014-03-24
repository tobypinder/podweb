class HomeController < ApplicationController

  require 'will_paginate/array'
  include PodcastsHelper

  def index
    if user_signed_in?
      entry_list = []
      current_user.podcasts.each do |podcast|
        get_feed(podcast).entries.each do |entry|
          entry_list << entry
        end
      end
      entry_list = entry_list.sort_by { |entry| entry.published }
      @entry_list_by_day = entry_list.group_by { |entry| entry.published.strftime("%B #{entry.published.day.ordinalize}, %Y") }
      @entry_list_by_day = @entry_list_by_day.sort_by { |date, entry_list| [Date.parse(date).year, Date.parse(date).month, Date.parse(date).day] }.reverse.paginate(page: params[:page], per_page: 3)
    end
  end
end