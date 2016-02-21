class FriendshipsController < ApplicationController
  include ApplicationHelper
  load_and_authorize_resource
  before_action :set_owner_of_wall, except: [:destroy, :update]
  before_action :set_friendship, only: [:destroy, :update]

  # GET /friendships
  # GET /friendships.json
  def index
    session[:last_friendship_page] = request.env['REQUEST_URI']
    @friendship = Friendship.new
    set_index_friendships
  end

  # POST /friendships
  # POST /friendships.json
  def create
    @friendship = Friendship.new
    @friendship.user1_id = current_user.id
    @friendship.user2_id = @owner.id
    @friendship.approved = false
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to friendships_main_path, flash: { :success => 'Request of friendship was successfully sent.' } }
        format.json { render :index, status: :created, location: @friendship }
      else
        set_index_friendships
        format.html { render :index }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    second_friendship = Friendship.find_by(:user1_id => @friendship.user2_id)
    @friendship.destroy
    second_friendship.destroy if second_friendship
    
    respond_to do |format|
      format.html { redirect_to back_page, flash: { :success => 'Friendship was deleted.' } }
      format.json { head :no_content }
    end
  end
  
  # PATCH/PUT /friendships/1
  # PATCH/PUT /friendships/1.json
  def update
    friendship_new = Friendship.new
    friendship_new.user1_id = @friendship.user2_id
    friendship_new.user2_id = @friendship.user1_id
    friendship_new.approved = true
    friendship_new.save!
    @friendship.approved = true
    respond_to do |format|
      if @friendship.save
        format.html { redirect_to back_page, flash: { :success => 'Friendship was approved.' } }
        format.json { render :index, status: :ok, location: @friendship }
      else
        set_index_friendships
        format.html { render :index }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def back_page
    if session[:last_friendship_page]
      session[:last_friendship_page]
    else
      friendships_path
    end
  end
  
  def set_index_friendships
    @friendships = Friendship.where("user1_id = :user AND approved = :approved", { user: @owner.id, approved: true})
    if (@owner == current_user) 
      @friendships_for_approval = Friendship.where(:user2_id => @owner, :approved => false)
    else
      @common_friendship = Friendship.where("(user1_id = :owner AND user2_id = :user) OR (user1_id = :user AND user2_id = :owner)", { user: current_user.id, owner: @owner.id})
    end
  end
  
  def set_owner_of_wall
    if params[:user_id]
      @owner = User.find(params[:user_id])
    else
      @owner = current_user
    end
  end
  
  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
