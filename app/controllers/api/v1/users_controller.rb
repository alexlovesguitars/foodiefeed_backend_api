module Api
  module V1
    class UsersController < ApplicationController

      def create
        user = User.new(user_params)
        if user.save
          session[:user_id] = user.id
          render json: user.slice(:id, :email, :created_at)
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find_by(id: session[:user_id])
        if user
          user.destroy
          session[:user_id] = nil
          render json: { message: 'User deleted' }
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

    end
  end
end
