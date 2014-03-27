class WatchedEpisodesController < ApplicationController

  def create
    watched_episode = WatchedEpisode.find_or_initialize_by(user_id: params[:watched_episode][:user_id], episode_id: params[:watched_episode][:episode_id])
    watched_episode.seconds_seen = params[:watched_episode][:seconds_seen]
    watched_episode.save
    render nothing: true
  end

end