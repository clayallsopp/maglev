module Maglev
  module_function

  def force_remote_relationship_syntax
    @force_remote_relationship_syntax
  end

  def force_remote_relationship_syntax=(v)
    @force_remote_relationship_syntax = v
  end

  def models
    Maglev::Model.models
  end
end