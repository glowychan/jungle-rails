class ReviewsController < ApplicationController
  before_filter :authorize, except: [:index, :show]

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.create(review_params)
    @review.user = current_user

    @review.save
    redirect_to product_path(@product)
  end

  def destroy
    @product = Product.find(params[:product_id])
    @review = @product.reviews.find(params[:id])
    @review.destroy
    redirect_to product_path(@product)
  end

  private
    def review_params
      params.require(:review).permit(:rating, :description)
    end
end
