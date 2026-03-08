module Api
  module V1
    class SessionsController < ApplicationController
      # Login
      def create
        user = User.find_by(email: params[:user][:email])

        if user&.authenticate(params[:user][:password])
          session[:user_id] = user.id
          render json: { id: user.id, email: user.email }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      # Logout
      def destroy
        session[:user_id] = nil
        head :no_content
      end

      def show
        if current_user
          render json: { id: current_user.id, email: current_user.email }
        else
          render json: { user: nil }, status: :unauthorized
        end
      end

      private

      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end
    end
  end
end
