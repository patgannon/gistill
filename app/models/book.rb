require "s3_store"

class Book
  include Mongoid::Document

  field :title, :type => String
  references_many :chapters
  belongs_to :user

  def file_store
    @file_store || S3Store.new
  end

  def file_store=(value)
    @file_store = value
  end

  def escaped_title
    #TODO: Make these unique
    URI.escape(title.gsub(' ', '_'))
  end

  def populate_chapters!
    chapters.each do |chapter|
      #chapter.title = "FOO" #TODO: Trigger content extraction
      chapter.load_content!
      chapter.save!
    end
  end

  def contents()
    file = file_store.read_file(get_path)
    file.body
  end

  def new_prawn_doc
    Prawn::Document.new
  end

  def render()
    pdf = new_prawn_doc
    pdf.text(title, :size => 30)
    chapters.each_with_index do |chapter, i|
      pdf.start_new_page
      pdf.text("Chapter #{i + 1} - #{chapter.title}", :size => 24)
      pdf.text("Author: #{chapter.author}", :size => 16)
      #TODO: Make this a link
      pdf.text("Source: #{chapter.url}", :size => 16)
      pdf.text(chapter.content)
    end

    file_store.write_file(get_path, pdf.render)
  end

  private

  def get_path()
    "#{id}.pdf"
  end
end
