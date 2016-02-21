class UsersController < ApplicationController
  include ApplicationHelper
  load_and_authorize_resource
  USERS_PER_PAGE = 60

  # GET /users_search
  # GET /users_search.json
  def index
    if params[:search]
      search = "%#{params[:search]}%"
      @users = User.where("first_name LIKE :search OR last_name LIKE :search OR (first_name || ' ' || last_name) LIKE :search", :search => search).page(params[:page]).per_page(USERS_PER_PAGE)
    else
      @users = User.none
    end
  end
end
