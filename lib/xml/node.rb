require 'nokogiri'
require File.expand_path('../diff',__FILE__)

class Nokogiri::XML::Node

  include Diff
  include Diff::Unordered
  #
  # Finds the differences between the node and another node.
  #
  # @param [Nokogiri::XML::Node] other
  #   The other node to compare against.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Boolean] :added
  #   Yield nodes that were added.
  #
  # @option options [Boolean] :removed
  #   Yield nodes that were removed.
  #
  # @option options [Boolean] :array_ordered
  #   If elements of array should be ordered when comparing
  #
  # @option options [Boolean] :ordered
  #   If other elements should be ordered when comparing
  #
  # @yield [change, node]
  #   The given block will be passed each changed node.
  #
  # @yieldparam [' ', '-', '+'] change
  #   Indicates whether the node stayed the same, was removed or added.
  #
  # @yieldparam [Nokogiri::XML::Node] node
  #   The changed node.
  #
  # @return [Boolean]
  #   Specifies whether the two nodes are same.
  #
  def diff(other,options={},&block)
    if (block && (options[:added] || options[:removed]))
      out = Proc.new{|change,node| 
                     if    (change == '+' && options[:added])   then yield change, node
                     elsif (change == '-' && options[:removed]) then yield change, node
                     end}
      return diff_tree(other, options, &out)
    else
      return diff_tree(other, options, &block)
    end
  end
  
end
