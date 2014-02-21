require 'nokogiri'
require File.expand_path('../lib/xml',__FILE__)

doc1 = Nokogiri::XML("<divs type='array'><div><a>A</a><b>B</b></div><div><a>C</a><b>D</b></div></divs>")
doc2 = Nokogiri::XML("<divs type='array'><div><b>D</b><a>C</a></div><div><b>B</b><a>A</a></div></divs>")

#doc1 = Nokogiri::XML(IO.read("browse_get_shows.xml"))
#doc2 = Nokogiri::XML(IO.read("browse_get_shows1.xml"))

doc1.diff(doc2, {:added => true, :removed => true, :ordered => true, :array_ordered => true}) do |change,node|
  puts "#{change} #{node.to_html}".ljust(50) + node.parent.path
end
#puts doc1.diff(doc2, {:added => true, :removed => true, :ordered => false, :array_ordered => false})

