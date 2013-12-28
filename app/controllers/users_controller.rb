class UsersController < ApplicationController
	def new
	  @user = User.new
	end

	def create
		user_params = params.require(:user).permit(:login, :email, :password)
		@user = User.new(user_params)
		if @user.save
			flash[:notice] = "Created a user for you! That's special."
			redirect_to @user
		else
			flash[:alert] = "Your user sucks: #{@user.errors.full_messages.join(', ')}"
			render :new
		end
	end

	def show
		@user = User.find(params[:id])
	end


	def index
		@user = User.all
	end
end
