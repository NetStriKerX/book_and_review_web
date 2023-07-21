class ReviewsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @review = @book.reviews.create(review_params)
    redirect_to book_path(@book)
  end

  def edit
    @review = Review.find(params[:id])
    @book = @review.book
  end

  def update
    @review = Review.find(params[:id])
    @review.update(review_params)
    redirect_to book_path(@review.book)
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star)
  end
end
