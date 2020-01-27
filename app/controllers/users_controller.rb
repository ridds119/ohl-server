class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: [:index, :create]
  after_action :verify_authorized 

  def index
    @users = User.all.with_attached_avatar 
    authorize User
    render json: @users
  end

  def show
    authorize @user
    render json: @user
  end

  def create
    user = User.new(secure_params)
    authorize user
    if user.save
      render json: User.all.with_attached_avatar
    else
      respond_with_errors(@user)
    end
  end

  def destroy
    authorize user
    if user.destroy
      render json: User.all.with_attached_avatar
    else
      render json: { error: 'Some error occured' }, status: :not_found
    end
  end

  def update
    authorize @user
    if @user.update(secure_params)
      @user.avatar.attach(secure_params[:photo])
      render json: User.all.with_attached_avatar
    else
      respond_with_errors @user
    end
  end

  def imageUpload
    authorize @user
    if @user.avatar.attached?
      @user.avatar.purge
    end
    if @user.avatar.attach(params["avatar"])
      render json: User.all.with_attached_avatar
    else
      render json: { error: 'Unable to update' }, status: :not_found
    end
  end

  # def fetchImage
  #   authorize @user
  #   if @user.avatar.attached?
  #     return plain: Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true)
  #   else 
  #     render json: { error: 'No image found' }, status: :not_found
  #   end
  # end

  private

  def set_user
    @user = User.find(params["id"])
  end

  # def secure_params
  #   ActiveModelSerializers::Deserialization.jsonapi_parse!(params,
  #       only: [:name, :email, :role, :password, :avatar])
  # end

  def secure_params
    params.require(:user).permit(:name, :email, :role, :password, :avatar)
  end

end
