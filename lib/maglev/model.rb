module Maglev
  class Model
    class << self
      include Maglev::Attributes
      include Maglev::Relationships

      if !Maglev.force_remote_relationship_syntax
        alias_method :has_many, :remote_has_many
        alias_method :has_one, :remote_has_one
        alias_method :has_one?, :remote_has_one?
        alias_method :belongs_to, :remote_belongs_to
        alias_method :belongs_to?, :remote_belongs_to?
      end

      attr_accessor :models

      def models
        @models ||= []
      end

      def inherited(subclass)
        self.models << subclass
      end

      def snake_case
        inspect.underscore
      end
    end

    include Maglev::Hashable
    include Maglev::RelationshipsInstance

    [:remote_has_many, :remote_has_one, :remote_belongs_to].each do |relationship|
      self.send(:define_method, relationship.to_s) do
        h = {}
        self.class.send(relationship).each do |name, hash|
          h[name] = self.send(name)
        end
        h
      end
    end

    if !Maglev.force_remote_relationship_syntax
      alias_method :has_many, :remote_has_many
      alias_method :has_one, :remote_has_one
      alias_method :belongs_to, :remote_belongs_to
    end
  end
end