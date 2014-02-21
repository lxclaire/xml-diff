module Diff

  #
  # Compare `self` and another node, consider them as trees and find the difference
  #
  # @param [#tdiff_each_child] other
  #   The other tree.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @yield [change, node]
  #   The given block will be passed the added or removed nodes.
  #
  # @yieldparam [' ', '+', '-'] change
  #   The state-change of the node.
  #
  # @yieldparam [Object] node
  #   A node from one of the two trees.
  #
  # @return [Boolean]
  #   Specifies whether the two nodes are same.
  #
  def diff_tree(other,options={},&block)
    # check if the nodes differ
    unless diff_equal(other)
      yield '-', self if block
      yield '+', other if block
      return false
    end
    yield ' ', self if block
    # compare the attributes of both
    res = true
    if self.kind_of?(Nokogiri::XML::Element) 
      res &= diff_attributes(other,&block)
    end
    return res unless res || block
    # compare the children of both  
    if self[:type] == "array"
      if options[:array_ordered] 
        res &= diff_children(other,options,&block)
      else 
        res &= diff_array_unordered(other,options,&block)
      end
    else
      if options[:ordered]
        res &= diff_children(other,options,&block)
      else
        res &= diff_children_unordered(other,options,&block)
      end
    end
    return res
  end
  
  protected
  
  #
  # Compares the XML/HTML node with another.
  #
  # @param [Nokogiri::XML::Node] node
  #   The other XMl/HTML node.
  #
  # @return [Boolean]
  #   Specifies whether the two nodes are equal.
  #
  def diff_equal(node)
    if (self.class == node.class)
      case node
      when Nokogiri::XML::Attr
        (self.name == node.name && self.value == node.value)
      when Nokogiri::XML::Element, Nokogiri::XML::DTD
        self.name == node.name
      when Nokogiri::XML::Text, Nokogiri::XML::Comment
        self.text == node.text
      when Nokogiri::XML::ProcessingInstruction
        (self.name == node.name && self.content = self.content)
      else
        false
      end
    else
      false
    end
  end
  #
  # Compares the attributes of 'self' with another node's.
  #
  # @param [Nokogiri::XML::Node] other
  #   The other XMl/HTML node.
  #
  # @yield [change, node]
  #   The given block will be passed the added or removed attribute_nodes.
  #
  # @yieldparam [' ', '+', '-'] change
  #   The state-change of the node.
  #
  # @yieldparam [Object] node
  #   A attribute node from one of the two nodes.
  #
  # @return [Boolean]
  #   Specifies whether the attributes of the two nodes are same.
  #
  def diff_attributes(other,&block)
    x = self.attribute_nodes
    y = other.attribute_nodes
    res = true
    x.each do |attri|
      if other[attri.name] == nil
        yield '-', attri if block
        res = false
        return res unless block
      elsif other[attri.name]==attri.value
        yield ' ', attri if block
      else
        yield '-', attri if block
        yield '+', other.attribute(attri.name) if block
        res = false
        return res unless block
      end   
    end
    y.each do |attri|
      if self[attri.name] == nil
        yield '+', attri if block
        res = false
        return res unless block
      end   
    end
    return res
  end
  #
  # Compares the differences between the child nodes, respecting the order of the nodes.
  #
  # @param [Nokogiri::XML::Node] other
  #   The other XMl/HTML node.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @yield [change, node]
  #   The given block will be passed the added or removed nodes.
  #
  # @yieldparam [' ', '+', '-'] change
  #   The state-change of the node.
  #
  # @yieldparam [Object] node
  #   A child node of one of the two nodes.
  #
  # @return [Boolean]
  #   Specifies whether the children of the two nodes are same.
  #
  def diff_children(other,options={},&block)
    x = self.children
    y = other.children
    if !x.length.eql?(y.length)
      puts "items of #{self.path} from file1: #{x.length}" if block
      puts "items of #{other.path} from file2: #{y.length}" if block
      return false 
    end
    res = true
    x.each_with_index do |xi,i|
      yi = y[i]
      res &= xi.diff_tree(yi,options,&block)
      return res unless res || block
    end
    return res
  end
  
end
