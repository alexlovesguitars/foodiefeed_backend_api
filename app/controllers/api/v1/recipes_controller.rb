module Api
  module V1
    class RecipesController < ApplicationController
      before_action :require_login
      before_action :set_recipe, only: [:show, :update, :destroy, :publish]
      before_action :authorize_recipe!, only: [:update, :destroy, :publish]

      # GET /api/v1/recipes
      def index
        # All public recipes + current user's recipes (including drafts)
        @recipes = Recipe.where("public = ? OR user_id = ?", true, current_user.id)
        render json: @recipes.as_json(only: [:id, :title, :description, :ingredients, :instructions, :dietary_tags, :prep_time, :cook_time, :public, :draft, :user_id])
      end

      # GET /api/v1/recipes/:id
      def show
        if @recipe.public? || @recipe.user_id == current_user.id
          render json: @recipe.as_json(only: [:id, :title, :description, :ingredients, :instructions, :dietary_tags, :prep_time, :cook_time, :public, :draft, :user_id])
        else
          render json: { error: "Not authorized to view this recipe" }, status: :forbidden
        end
      end

      # POST /api/v1/recipes
      def create
        @recipe = current_user.recipes.new(recipe_params)

        # Ensure draft-first behavior
        @recipe.draft = true if @recipe.draft.nil?
        @recipe.public = false if @recipe.public.nil?

        if @recipe.save
          render json: @recipe.as_json(only: [:id, :title, :description, :ingredients, :instructions, :dietary_tags, :prep_time, :cook_time, :public, :draft, :user_id]), status: :created
        else
          render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/recipes/:id
      def update
        # Regular users cannot change public/draft flags manually
        if current_user.user?
          params[:recipe].delete(:public) if params[:recipe].key?(:public)
          params[:recipe].delete(:draft) if params[:recipe].key?(:draft)
        end

        if @recipe.update(recipe_params)
          render json: @recipe.as_json(only: [:id, :title, :description, :ingredients, :instructions, :dietary_tags, :prep_time, :cook_time, :public, :draft, :user_id])
        else
          render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/recipes/:id
      def destroy
        @recipe.destroy
        head :no_content
      end

      # PATCH /api/v1/recipes/:id/publish
      def publish
        if @recipe.draft?
          @recipe.update(draft: false, public: true)
          render json: @recipe.as_json(only: [:id, :title, :description, :ingredients, :instructions, :dietary_tags, :prep_time, :cook_time, :public, :draft, :user_id])
        else
          render json: { error: "Recipe is already published" }, status: :unprocessable_entity
        end
      end

      private

      def recipe_params
        permitted = [:title, :description, :ingredients, :instructions, :dietary_tags, :prep_time, :cook_time]
        permitted << :public if current_user.creator?
        permitted << :draft if current_user.creator?
        params.require(:recipe).permit(permitted)
      end

      def set_recipe
        @recipe = Recipe.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Recipe not found" }, status: :not_found
      end

      def authorize_recipe!
        unless @recipe.user_id == current_user.id
          render json: { error: "Not authorized to modify this recipe" }, status: :forbidden
        end
      end

      def current_user
        @current_user ||= User.find_by(id: session[:user_id])
      end

      def require_login
        unless current_user
          render json: { error: "Not authorized" }, status: :unauthorized
        end
      end
    end
  end
end
