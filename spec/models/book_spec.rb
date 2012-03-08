require 'spec_helper'

describe Book do
	it "produces valid URI fragments for books" do
		book = Book.new :title => "my test"
		book.escaped_title.should == "my_test"
	end
end
