class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized
  def index
    @users = User.all.with_attached_image 
    authorize User
    render json: @users
  end

  def show
    @user = User.find(params["id"])
    authorize @user
    render json: @user
  end

  def create
    user = User.new(secure_params)
    authorize user
    if user.save
      render json: User.all.with_attached_image
    else
      render json: { error: "Unable to Create" }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params["id"])
    authorize user
    if user.destroy
      render json: User.all.with_attached_image
    else
      render json: { error: 'Some error occured' }, status: :not_found
    end
  end

  def update
    @user = User.find(params["id"])
    authorize @user
    if @user.update(secure_params)
      render json: User.all.with_attached_image
    else
      render json: { error: "Unable to update" }, status: :not_found
    end
  end

  def imageUpload
    @user = User.find(params["id"])
    authorize @user
    if @user.avatar.attached?
      @user.avatar.purge
    end
    if @user.avatar.attach(params["avatar"])
      render json: User.all.with_attached_image
    else
      render json: { error: 'Unable to update' }, status: :not_found
    end
  end

  # def fetchImage
  #   @user = User.find(params["id"])
  #   authorize @user
  #   if @user.avatar.attached?
  #     return plain: Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true)
  #   else 
  #     render json: { error: 'No image found' }, status: :not_found
  #   end
  # end

  private

  def secure_params
    params.require("user").permit(:name, :email, :role, :password, :avatar)
  end

end
