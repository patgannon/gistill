require 'open-uri'

class Chapter
  include Mongoid::Document

  field :title, :type => String
  field :author, :type => String
  field :url, :type => String
  field :content, :type => String
  referenced_in :book

  def load_content!
    begin
      doc = Pismo::Document.new(url)
      self.title = doc.title
      self.content = doc.body
    rescue Exception => ex
      self.title = "Could not load article"
    end
  end

  def load_content_old!
    doc = Nokogiri::HTML(open(url))

    title_node = doc.xpath("//head/title")[0]
    if (title_node)
      self.title = title_node.text
      save!
    end

    body_node = doc.xpath("//body")[0]
    return nil unless body_node

    self.content = get_content(body_node)
    #get_content(body_node, body_node.text.length)
  end

#TODO: Dig through frame-set(s)


def get_content2(node, total_text_length)
  text_length = node.text.length
  html_length = node.inner_html.length

  node.elements.sort {|n1, n2| n2.text.length <=> n1.text.length}.each do |element|
    total_text_ratio = element.text.length.to_f / total_text_length.to_f

    if total_text_ratio > 0.5
      get_content(element, total_text_length)
    end
  end

  node.inner_html
end

def text_length(node)
  node.text.gsub(" ", "").length
end

def get_content(node)
  text_length = text_length(node)
  #puts "get_content: #{node.name}"

  if (node.elements.length == 0)
    return node.text
  elsif (node.elements.length == 1)
    return get_content(node.elements[0])
  else
    variance = linear_variance(node.elements.map {|n| text_length(n)})
    coefficient = 100 * variance / text_length.to_f
    #puts "recursing(#{coefficient}/#{variance}): #{node.text[1,200]}"
    #puts "--------------------------------"
    #puts "#{node.text[-200, 200]}"

    if (coefficient < 25)
      return node.to_html
    else
      longest_node = node.elements.sort{|n1, n2| text_length(n2) <=> text_length(n1)}[0]
      return get_content(longest_node)
    end
  end
end

  def sum(values)
    values.inject( nil ) { |sum,x| sum ? sum+x : x }
  end
  
  def mean(values)
    sum(values)/values.size.to_f; 
  end

  def linear_variance(values)
    mean = mean(values)
    Math.sqrt(values.inject( nil ) { |var,x| var ? var+((x-mean)**2) : ((x-mean)**2)}/values.size.to_f)
  end

#  def sum3(values, &blk)
#    values.map(&blk).inject { |sum, element| sum + element }
#  end
#
#  def mean3(values)
#    (sum3(values).to_f / values.size.to_f)
#  end
#
#  def linear_variance3(values)
#    m = mean3(values)
#    sum3(values) { |i| (i-m)**2} / values.size
#
#  def linear_variance2(values)
#    n, mean, s = [0, 0, 0]
#    values.each_with_index do |x,n|
#      delta = (x - mean).to_f
#      mean += delta/(n+1)
#      s += delta*(x - mean)
#    end
#    s/n
#  end
#
#  def linear_variance1(values)
#    mean = (values.inject(0.0) {|s,x| s + x}) / Float(values.length)
#    values.inject(0.0) {|s,x| s + (x - mean)**2}
#  end

end

