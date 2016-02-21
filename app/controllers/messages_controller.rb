class MessagesController < ApplicationController
  include ApplicationHelper
  load_and_authorize_resource
  before_action :set_user, only: [:show, :create]
  MESSAGES_PER_PAGE = 25

  # GET /messages
  # GET /messages.json
  def index
    @user = current_user
    @last_messages = Message.find_by_sql("SELECT MAX(maxid) AS id FROM (SELECT MAX(id) AS maxid, receiver_id AS user_id FROM messages WHERE sender_id='#{current_user.id}' GROUP BY sender_id, receiver_id UNION SELECT MAX(id) AS maxid, sender_id AS user_id FROM messages WHERE receiver_id='#{current_user.id}' GROUP BY receiver_id, sender_id) helper GROUP BY user_id ORDER BY MAX(maxid) DESC")
  end
  
  # GET /messages/1/1
  # GET /messages/1/1.json
  def show
    set_messages
    @message = Message.new
    @message.sender = current_user
    @message.receiver = @user
  end

  # POST /messages/1/1
  # POST /messages/1/1.json
  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    @message.receiver = @user
    @message.read = false
    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_user_path(@user.id, 1), flash: { :success => 'Message was successfully sent.' } }
        format.json { render :index, status: :created, location: @message }
      else
        set_messages
        format.html { render :show }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params[:message].permit(:text)
  end
  
  def set_messages
    @messages = Message.where("(sender_id = :user AND receiver_id = :this_user) OR (sender_id = :this_user AND receiver_id = :user)", :user => @user.id, :this_user => current_user.id).order(id: :desc).page(params[:page]).per_page(MESSAGES_PER_PAGE)
  end
  
  def set_user
    @user = User.find(params[:user_id])
  end
end
