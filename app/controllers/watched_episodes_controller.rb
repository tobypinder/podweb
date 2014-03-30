class WatchedEpisodesController < ApplicationController

  def create
    if user_signed_in?
      watched_episode = WatchedEpisode.find_or_initialize_by(user_id: current_user.id, episode_id: params[:watched_episode][:episode_id])
      watched_episode.watched = params[:watched_episode][:watched]
      watched_episode.seconds_seen = params[:watched_episode][:seconds_seen]
      watched_episode.save
    end
    render nothing: true
  end

end