class Api::SessionsController < ApplicationController
  def create
    @user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password]
    )
    if @user.save
      login(@user)
      render 'api/users/show'
    else
      render json: ['invalid crednetials'] status: 404
    end
  end

  def destroy
    if !current_user
      render status: 404
    else
      logout!
      render json: {}
    end
  end
end
