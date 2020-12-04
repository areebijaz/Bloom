class Product < ApplicationRecord
  belongs_to :brand, dependent: :destroy
  has_many :product_ingredients
  has_many :ingredients, through: :product_ingredients
  has_many :product_reviews

  validates :title, presence: true, uniqueness: true

  def safety_rating
    product_ingredients = ProductIngredient.where(product: self)

    all_ingredients_safety_rating_total = []
    count = 0

    if  product_ingredients.nil?
      product_safety_rating = 0
    else
      product_ingredients.each do |product_ingredient|
        all_ingredients_safety_rating_total << product_ingredient.ingredient.average_safety_rating
        product_ingredient.ingredient.average_safety_rating.nil? ? product_safety_rating = 0 : count += 10
      end
        product_safety_rating = (all_ingredients_safety_rating_total.sum.fdiv(count)) * 100 if count > 0
    end
    product_safety_rating
  end

 def efficacy_rating
   product_ingredients = ProductIngredient.where(product: self)

    all_ingredients_efficacy_rating_total = []
    count = 0

    if  product_ingredients.nil?
      product_efficacy_rating = 0
    else
      product_ingredients.each do |product_ingredient|
        all_ingredients_efficacy_rating_total << product_ingredient.ingredient.average_efficacy_rating
        product_ingredient.ingredient.average_efficacy_rating.nil? ? product_efficacy_rating = 0 : count += 10
      end
        product_efficacy_rating = (all_ingredients_efficacy_rating_total.sum.fdiv(count)) * 100 if count > 0
    end
    product_efficacy_rating
  end

  include PgSearch::Model
  pg_search_scope :product_and_brand_search,
    against: [ :title, :description, :oneliner, :category, :sub_category ],
    associated_against: {
      brand: [ :name ]
    },
    using: {
      tsearch: { prefix: true }
    }
end
