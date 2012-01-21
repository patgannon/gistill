class BooksController < ApplicationController
  #before_filter :authenticate_user!

  def index
    @books = current_user.books
  end

  def show
    @book = Book.find(params[:id])
  end

  def download
    book = Book.find(params["id"])
    path = "public/PDF/#{book.escaped_title}.pdf"
    book.render path
    #render :text=>"id = #{params[:id]}, folder = #{Dir.pwd}/public#{path}"
    #redirect_to path
    #TODO: Send out-process, and maybe send mime-type
    send_file "#{Dir.pwd}/#{path}"
  end

  def new
  end

  def create
    chapters = params["chapters"].map {|number, hash| [number, Chapter.new(hash)]}.sort {|c1, c2| c1[0] <=> c2[0]}.map {|c| c[1]}
    #TODO: Fix case of no chapters (validation?)
    book = Book.create! params["book"].merge(:user => current_user,
      :chapters => chapters)
    book.populate_chapters!

    #TODO: URL-encode book title AFTER replacing spaces with underscores
    #redirect_to :show, :id => book.id, :title => book.title.gsub(" ", "_")
    redirect_to "/books/#{book.id}/#{book.escaped_title}"
  end
end
