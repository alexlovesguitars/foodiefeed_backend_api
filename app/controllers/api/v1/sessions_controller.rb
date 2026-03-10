module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_request, only: [:create]

      # Login
      def create
        user = User.find_by(email: params[:user][:email])

        if user&.authenticate(params[:user][:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { token: token, user: { id: user.id, email: user.email }, message: "Logged in successfully" }
        else
          render json: { error: "Invalid credentials" }, status: :unauthorized
        end
      end

      # Logout
      def destroy
        session[:user_id] = nil
        render json: { message: "Logged out successfully" }
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
