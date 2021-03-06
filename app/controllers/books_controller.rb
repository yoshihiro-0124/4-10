class BooksController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit, :update, :destroy]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    @books = Book.all
    if @book.save
     redirect_to book_path(@book.id), notice: 'You have created book successfully.'
    else
     @user = current_user
     render :index
    end
  end

  def show
     @bookr = Book.new
     @book = Book.find(params[:id])
     @user = User.find_by(id:@book.user_id)
    # @book.userでもあり
  end

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
    # findはindexアクションではだめ
    # current_user
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
    redirect_to book_path(@book.id), notice: 'You have updated book successfully.'
    else
    render "books/edit"
    end
  end


  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

 private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
     unless @book.user == current_user
     redirect_to books_path
     end
  end
end