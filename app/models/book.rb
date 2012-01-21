class Book
  include Mongoid::Document

  field :title, :type => String
  references_many :chapters
  belongs_to :user

  def escaped_title
    URI.escape(title.gsub(' ', '_'))
  end

  def populate_chapters!
    chapters.each do |chapter|
      #chapter.title = "FOO" #TODO: Trigger content extraction
      chapter.load_content!
      chapter.save!
    end
  end

  def render(path)
    pdf = Prawn::Document.new
    pdf.text(title, :size => 30)
    chapters.each_with_index do |chapter, i|
      pdf.start_new_page
      pdf.text("Chapter #{i + 1} - #{chapter.title}", :size => 24)
      pdf.text("Author: #{chapter.author}", :size => 16)
      #TODO: Make this a link
      pdf.text("Source: #{chapter.url}", :size => 16)
      pdf.text(chapter.content)
    end

    pdf.render_file path
  end
end
