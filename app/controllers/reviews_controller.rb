class ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update destroy]
  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.create(review_params)
    redirect_to book_path(@book)
  end

  def edit
    @book = @review.book
  end

  def update
    @review.update(review_params)
    redirect_to book_path(@review.book)
  end

  def destroy
    @review.destroy
    redirect_to @review.book
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star)
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
