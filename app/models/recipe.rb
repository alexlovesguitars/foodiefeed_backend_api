class Recipe < ApplicationRecord
  belongs_to :user
  validates :title, :description, :ingredients, :instructions, presence: true
  validates :public, inclusion: { in: [true, false] }

  before_create :set_default_draft_and_visibility

  private

  def set_default_draft_and_visibility
    # All new recipes are drafts by default
    self.draft = true if draft.nil?
    self.public = false if public.nil?  # starts private
  end


  scope :public_recipes, -> { where(public: true) }
  scope :owned_by, ->(user) { where(user_id: user.id) }

end
