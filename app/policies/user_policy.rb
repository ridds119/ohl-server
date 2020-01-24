class UserPolicy
	attr_reader :current_user, :model
	
	def initialize(current_user, model)
		@current_user = current_user
		@user = model
	end

	def index?
		@current_user.admin?
	end

	def show?
		@current_user.admin? || @current_user == @user
	end

	def create?
		@current_user.admin?
	end

	def update?
		@current_user.admin? || @current_user == @user
	end

	def destroy?
		return false if @current_user == @user
		@current_user.admin?
	end

	def imageUpload?
		@current_user.admin? || @current_user == @user
	end

	def fetchImage?
		@current_user.admin? || @current_user == @user
	end
end 