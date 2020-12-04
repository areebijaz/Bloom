class Ingredient < ApplicationRecord
  has_many :product_ingredients
  has_many :ingredient_reviews

  validates :name, presence: true, uniqueness: true

  validates :description, presence: true
  def safety_rating
    ingredient_review = IngredientReview.where(ingredient: self)
    safety_rating = ingredient_review.average(:safety_rating)
    self.update(average_safety_rating: safety_rating)
    self.average_safety_rating
  end
  
  def efficacy_rating
    ingredient_review = IngredientReview.where(ingredient: self)
    efficacy_rating = ingredient_review.average(:efficacy_rating)
    self.update(average_efficacy_rating: efficacy_rating)
    self.average_efficacy_rating
  end

  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
    against: [ :name, :description ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

end
