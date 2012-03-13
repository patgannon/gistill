class BooksController < ApplicationController
  #before_filter :authenticate_user!
  authorize_resource

  def index
    @books = current_user.books
  end

  def show
    @book = Book.find(params[:id])
  end

  def download
    book = Book.find(params["id"])
    book.render

    #TODO: Send out-process, and maybe send mime-type
    send_data book.contents, :filename => "#{book.title.gsub(' ', '_')}.pdf", :type => "application/pdf"
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
