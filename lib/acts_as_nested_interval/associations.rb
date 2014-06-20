module ActsAsNestedInterval
  module Associations
    extend ActiveSupport::Concern

    included do 
      scope :ancestors_of, ->(node){ where("rgt >= CAST(:rgt AS FLOAT) AND lft < CAST(:lft AS FLOAT)", rgt: node.rgt, lft: node.lft) }
      scope :descendants_of, ->(node){ where( "id != :id AND lft BETWEEN :lft AND :rgt", id: node.id, rgt: node.rgt, lft: node.lft ) } # Simple version
      scope :siblings_of, ->(node){ fkey = nested_interval.foreign_key; where( fkey => node.send(fkey) ).where.not(id: node.id) }
    end

    def ancestor_of?(node)
      left < node.left && right >= node.right
    end

    def ancestors
      nested_interval_scope.ancestors_of(self)
    end

    def descendants
      nested_interval_scope.descendants_of(self)
    end

    def siblings
      nested_interval_scope.siblings_of(self)
    end


  end
end