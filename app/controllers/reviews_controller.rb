class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[edit update destroy]
  before_action :authorization, only: %i[update destroy]

  def create
    @book = Book.find(params[:book_id])
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
    if @review.update(review_params)
      redirect_to book_path(@review.book)
    else
      redirect_to edit_book_review_path(error: @review.errors.full_messages)
    end
  end

  def destroy
    if @review.destroy
      redirect_to @review.book
    else
      redirect_to book_review_path(error: @review.errors.full_messages)
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :star).tap do |review_params|
      review_params[:user_id] = current_user.id
    end
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def authorization
    authorize @review, policy_class: ReviewPolicy
  end
end
