class ProductsController < ApplicationController

  def index
    if params[:query].present?
      @products = Product.product_and_brand_search(params[:query])
    elsif params[:tag].present?
      @products = Product.tagged_with(params[:tag])
    else
      @products = Product.all
    end
    add_breadcrumb('/  Products', products_path, true)
  end

  def new
    # we need @booking in our `simple_form_for`
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render :new
    end
  end 

   def show
    @product = Product.find(params[:id])
    @product_review = ProductReview.new
    @product_ingredients = ProductIngredient.where(product: @product)
    add_breadcrumb("/  Products", products_path, false)
    add_breadcrumb("/  #{@product.title}", nil, true)
  end

  def favorite
    @product = Product.find(params[:id])
    @user = current_user
    @user.favorite(@product)
    redirect_to @product
  end

  def unfavorite
    @product = Product.find(params[:id])
    @user = current_user
    @user.unfavorite(@product)
    redirect_to @product
  end

  private


  def product_params
    params.require(:product).permit(:title, :brand_id, :description, :average_product_rating_stars, :average_efficacy_rating_bar, :average_safety_rating_bar, tag_list: [])
  end
end


