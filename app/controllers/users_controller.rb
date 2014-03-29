class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :correct_user?

  def show
    @user = User.find(params[:id])
    @podcasts = @user.podcasts.sort_by { |podcast| podcast.title.sub(/^(the|a|an)\s+/i, '') }
  end

end