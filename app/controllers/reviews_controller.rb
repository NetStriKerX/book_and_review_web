class ReviewsController < ApplicationController
  before_action :set_review, only: %i[edit update destroy]
  before_action :authenticate_user!

  def create
    @book = Book.find(params[:book_id])
    review_params = params.require(:review).permit(:comment, :star, :user_id)
    review_params[:user_id] = current_user.id
    if @book.reviews.create(review_params)
      redirect_to book_path(@book)
    else
      redirect_to book_review_path(error: @book.errors_full_messages)
    end
  end

  def edit
    @book = @review.book
  end

  def update
    authorize @review, policy_class: ReviewPolicy
    if @review.update(review_params)
      redirect_to book_path(@review.book)
    else
      redirect_to edit_book_review_path(error: @review.errors.full_messages)
    end
  end

  def destroy
    authorize @review, policy_class: ReviewPolicy
    if @review.destroy
      redirect_to @review.book
    else
      redirect_to book_review_path(error: @review.errors.full_messages)
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star)
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
