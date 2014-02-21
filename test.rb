require 'nokogiri'
require File.expand_path('../lib/xml',__FILE__)

doc1 = Nokogiri::XML(IO.read("test1.xml"))
doc2 = Nokogiri::XML(IO.read("test1.xml"))

doc1.diff(doc2, {:added => true, :removed => true, :ordered => false, :array_ordered => false}) do |change,node|
  puts "#{change} #{node.to_html}".ljust(50) + node.parent.path
end

#puts doc1.diff(doc2, {:added => true, :removed => true, :ordered => false, :array_ordered => false})

