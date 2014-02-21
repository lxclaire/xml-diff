module Diff

  #
  # Calculates the differences between two trees, without respecting the order of children nodes.
  #
  module Unordered  
 
    protected

    #
    # Compares the differences between the child nodes, without respecting the order of the nodes.
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
    def diff_children_unordered(other,options={},&block)
      x = self.children.sort_by(&:name)
      y = other.children.sort_by(&:name)
      if !x.length.eql?(y.length)
        puts "items of #{self.path} from file1 : #{x.length}"
        puts "items of #{other.path} from file2 : #{y.length}"
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
    #
    # Compares the differences between the two arrays, without respecting the order of the nodes.
    #
    # @param [Nokogiri::XML::Node] other
    #   The other array.
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
    #   A node from one of the two arrays.
    #  
    # @return [Boolean]
    #   Specifies whether the two arrays are same.
    #
    def diff_array_unordered(other,options={},&block)
      x = self.children
      y = other.children
      if !x.length.eql?(y.length)
        #puts "items of #{self.path} from file1 : #{x.length}"
        #puts "items of #{other.path} from file2 : #{y.length}"
        return false unless block
      end
      res = true
      match = {}
      changes = []
      x.each_with_index do |xi,i|
        y.each_with_index do |yj,j|
          if (!match.has_value?(j) && xi.diff_tree(yj,options))
            match[i] = j
            changes << [i, ' ', xi]
          end
        end
        unless match.has_key?(i)
          changes << [i, '-', xi] 
          res = false
          return res unless block
        end
      end
      y.each_with_index do |yj,j|
        unless match.has_value?(j)
          changes << [j, '+', yj] 
          res = false
          return res unless block
        end
      end
      changes.sort_by { |change| change[0] }.each do |index,change,node|
        yield change,node if block
      end
      changes = nil
      match = nil
      return res
    end 
    
  end
  
end
