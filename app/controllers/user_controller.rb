class UserController < ApplicationController

  def index
  end

  def new
   
  end

  def create
   
    end
    
  end

  def profile
    @user = current_user
  end

  def edit
  end

  def update
   
  end

  def destroy
    
  end

  
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
