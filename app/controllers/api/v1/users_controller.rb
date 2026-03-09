module Api
  module V1
    class UsersController < ApplicationController
      before_action :require_login, only: [:show, :update, :destroy]

      def create
        user = User.new(user_params)
        if user.save
          session[:user_id] = user.id
          render json: user.slice(:id, :email, :created_at)
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        if current_user
          render json: current_user.slice(:id, :email, :created_at)
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      def update

        if current_user
          if current_user.update(user_params)
            render json: current_user.slice(:id, :email, :created_at)
          else
            render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      def destroy
        if current_user
          current_user.destroy
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

      def current_user
        User.find_by(id: session[:user_id])
      end

      def require_login
        unless session[:user_id]
          render json: { error: "Not authorized" }, status: :unauthorized
        end
      end
    end
  end
end
