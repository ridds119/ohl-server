class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, except: [:index, :create]
  after_action :verify_authorized 

  def index
    @users = User.all
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
      render json: User.all
    else
      respond_with_errors(@user)
    end
  end

  def destroy
    authorize user
    if user.destroy
      render json: User.all
    else
      render json: { error: 'Some error occured' }, status: :not_found
    end
  end

  def update
    authorize @user
    if @user.update(secure_params)
      if params[:avatar]
        @user.avatar.attach(data: params[:avatar])
      end
      render json: User.all
    else
      respond_with_errors @user
    end
  end

  def imageUpload
    authorize @user
    if @user.avatar.attached?
      @user.avatar.purge
    end
    
    if params[:avatar]
      if @user.avatar.attach(params[:avatar])
        render json: { "path": @user.get_avatar_url}, status: :ok
      end
    else
      render json: { error: 'Unable to update' }, status: :not_found
    end
  end

  def fetchImage
    authorize @user
    if @user.avatar.attached?
      render json: { "path": @user.get_avatar_url}, status: :ok
    else 
      render json: { error: 'No image found' }, status: :not_found
    end
  end

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
    # params.require(:user).permit(:name, :email, :role, :password, avatar: :data)
  end

end
