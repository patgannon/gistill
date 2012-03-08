require 'spec_helper'

describe Chapter do
	it "loads title from HTML" do
		static_html = %q!
		<html>
		<head><title>my test page</title></head>
		<body>Here is some content</body>
		</html>
		!
		chapter = Chapter.new :url => static_html
		chapter.load_content!
		chapter.title.should == "my test page"
	end
end
