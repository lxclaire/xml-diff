require File.expand_path('../node',__FILE__)

class Nokogiri::XML::Document < Nokogiri::XML::Node

  #
  # Overrides `diff_tree` to only compare the child nodes of the document.
  #
  def diff_tree(tree,options={},&block)
    return diff_children(tree,options,&block)
  end

end
