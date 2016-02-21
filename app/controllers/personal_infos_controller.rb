class PersonalInfosController < ApplicationController
  include ApplicationHelper
  load_and_authorize_resource
  before_action :set_owner_of_wall, except: [:destroy, :update]
  before_action :set_personal_info, only: [:destroy, :update, :edit]

  # GET /
  def index
    if user_signed_in?
      set_index_personal_infos
      @personal_info = PersonalInfo.new
      @personal_info.user_id = @owner.id
    elsif request.env['PATH_INFO'] != root_path
      authorize! :read, @owner
    end
  end

  # POST /
  def create
    @personal_info = PersonalInfo.new(personal_info_params)
    @personal_info.user_id = @owner.id
    respond_to do |format|
      if @personal_info.save
        format.html { redirect_to root_path, flash: { :success => 'Personal information was successfully saved.' } }
        format.json { render :index, status: :created, location: @personal_info }
      else
        set_index_personal_infos
        format.html { render :index }
        format.json { render json: @personal_info.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /personal_infos/1/edit
  # GET /personal_infos/1/edit.json
  def edit
  end
  
  # DELETE /personal_infos/1
  # DELETE /personal_infos/1.json
  def destroy
    @personal_info.destroy
    respond_to do |format|
      format.html { redirect_to root_path, flash: { :success => 'Personal info was deleted.' } }
      format.json { head :no_content }
    end
  end
  
  # PATCH/PUT /personal_infos/1
  # PATCH/PUT /personal_infos/1.json
  def update
    respond_to do |format|
      if @personal_info.update(personal_info_params)
        format.html { redirect_to root_path, flash: { :success => 'Personal info was successfully edited.' } }
        format.json { render :index, status: :ok, location: @personal_info }
      else
        format.html { render :edit }
        format.json { render json: @personal_info.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def personal_info_params
    params[:personal_info].permit(:text, :title)
  end
  
  def set_index_personal_infos
    @personal_infos = PersonalInfo.where(:user_id => @owner.id).order(:title)
  end
  
  def set_owner_of_wall
    if params[:user_id]
      @owner = User.find(params[:user_id])
    else
      @owner = current_user
    end
  end
  
  def set_personal_info
    @personal_info = PersonalInfo.find(params[:id])
  end
end
