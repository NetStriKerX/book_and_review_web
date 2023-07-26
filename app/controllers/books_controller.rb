class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authorization, only: %i[update destroy]

  def index
    @books = Book.page(params[:page]).per(10)
  end

  def show
    @reviews = @book.reviews.page(params[:page]).per(10)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book
    else
      redirect_to new_book_path(error: @book.errors.full_messages)
    end
  end

  def edit;  end

  def update
    if @book.update(book_params)
      redirect_to @book
    else
      redirect_to edit_book_path(error: @book.errors.full_messages)
    end
  end

  def destroy
    if @book.destroy
      redirect_to books_path
    else
      redirect_to books_path(error: @book.errors.full_messages)
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :description, :release).tap do |param|
      param[:user_id] = current_user.id
    end
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def authorization
    authorize @book, policy_class: BookPolicy
  end
end
