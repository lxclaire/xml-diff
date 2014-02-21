# xml-diff

Comparing two XML/HTML documents and output the differences.

## Examples

    require 'nokogiri'
    require File.expand_path('../lib/xml',__FILE__)

    doc1 = Nokogiri::XML("<divs type='array'><div><a>A</a><b>B</b></div><div><a>C</a><b>D</b></div></divs>")
    doc2 = Nokogiri::XML("<divs type='array'><div><b>D</b><a>C</a></div><div><b>B</b><a>A</a></div></divs>")

    doc1.diff(doc2, {:added => true, :removed => true, :ordered => true, :array_ordered => true}) do |change,node|
      puts "#{change} #{node.to_html}".ljust(50) + node.parent.path
    end

    # - <a>A</a>                                        /divs/div[1]
    # + <b>D</b>                                        /divs/div[1]
    # - <b>B</b>                                        /divs/div[1]
    # + <a>C</a>                                        /divs/div[1]
    # - <a>C</a>                                        /divs/div[2]
    # + <b>B</b>                                        /divs/div[2]
    # - <b>D</b>                                        /divs/div[2]
    # + <a>A</a>                                        /divs/div[2]

Only consider the order of arrays:

    doc1.diff(doc2, {:added => true, :removed => true, :ordered => false, :array_ordered => true}) do |change,node|
      puts "#{change} #{node.to_html}".ljust(50) + node.parent.path
    end

    # - A                                               /divs/div[1]/a
    # + C                                               /divs/div[1]/a
    # - B                                               /divs/div[1]/b
    # + D                                               /divs/div[1]/b
    # - C                                               /divs/div[2]/a
    # + A                                               /divs/div[2]/a
    # - D                                               /divs/div[2]/b
    # + B                                               /divs/div[2]/b
  
Don't consider the order, there is no output

    doc1.diff(doc2, {:added => true, :removed => true, :ordered => false, :array_ordered => false}) do |change,node|
      puts "#{change} #{node.to_html}".ljust(50) + node.parent.path
    end

Only find the added nodes:

    doc1.diff(doc2, {:added => true, :removed => false, :ordered => false, :array_ordered => true}) do |change,node|
      puts "#{change} #{node.to_html}".ljust(50) + node.parent.path
    end

    # + C                                               /divs/div[1]/a
    # + D                                               /divs/div[1]/b
    # + A                                               /divs/div[2]/a
    # + B                                               /divs/div[2]/b

## Requirements

* [ruby](http://www.ruby-lang.org/) >= 1.8.7
* [nokogiri](http://nokogiri.rubyforge.org/) ~> 1.5
