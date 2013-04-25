class UsersController < ApplicationController
  # Requires current user to be signed in
  before_filter :authenticate_user!
  
  def show_token
    @user = current_user
    render "token"
  end

end
