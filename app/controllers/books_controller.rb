class BooksController < ApplicationController
  def index
    @books = Book.all.order(:updated_at)
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @editted_book = Book.find(params[:id])  #ここポイントしっかりshowアクションにもこの変数の形で渡さないとupdateアクションから遷移することができなくなる
  end

  def create
    @book = Book.new(book_params) #エラーどこに入っているのかをしっかり確認しろ、その上でしっかりrenderに送らないとエラー文は表示されないでしょ。
    if @book.save
      flash[:success] = 'Book was successfully created.'
      redirect_to book_path(@book.id)
    else
      @books = Book.all #ここでしっかり渡さないからrender :indexが機能しなかったってこと！
      render :index #newとindexを同じ画面にしているため一覧を出すためのeachがうまく機能せず(for nillclass)となりエラ〜になる。→しっかり今回の場合は@booksを定義すること
    end
  end

  def edit
    @book = Book.find(params[:id])
    @editted_book = Book.find(params[:id])
  end

  def update
    @editted_book = Book.find(params[:id])
    if @editted_book.update(book_params)
      flash[:success] ='Book was successfully updated.'
      redirect_to book_path(@editted_book.id)
    else
      @book = Book.find(params[:id])
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    if book.destroy
      flash[:destroy] = 'Book was successfully destroyed.'
      redirect_to books_path
    end
  end

  private
  def book_params
    params.require(:book).permit(:title,:body)
  end
end
