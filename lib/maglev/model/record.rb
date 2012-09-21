module Maglev
  module Record
    def find(id, params = {}, &block)
      get(member_path.format(params.merge(id: id))) do |response, json|
        if response.ok?
          obj = self.new(json)
          request_block_call(block, obj, response)
        else
          request_block_call(block, nil, response)
        end
      end
    end

    def find_all(params = {}, &block)
      get(collection_path.format(params)) do |response, json|
        if response.ok?
          objs = []
          arr_rep = nil
          if json.class == Array
            arr_rep = json
          elsif json.class == Hash
            [self.inspect.pluralize.to_sym, self.collection_options[:json_path]].collect do |key_path|
              if json.include? key_path
                arr_rep = json[key_path]
              end
            end
          else
            # the returned data was something else
            # ie a string, number
            request_block_call(block, nil, response)
            return
          end
          arr_rep && arr_rep.each { |one_obj_hash|
            objs << self.new(one_obj_hash)
          }
          request_block_call(block, objs, response)
        else
          request_block_call(block, nil, response)
        end
      end
    end

    # Enables the find
    private
    def request_block_call(block, default_arg, extra_arg)
      raise Maglev::Error::BlockRequiredError, "No block given" if !block
      case block.arity
      when 1
        block.call default_arg
      when 2
        block.call default_arg, extra_arg
      else
        raise Maglev::Error::BlockArgumentsError, "Incorrect block arguments; need 1 or 2"
      end
    end
  end

  module RecordInstance
    # EX
    # a_model.destroy do |response, json|
    #   if json[:success]
    #     p "success!"
    #   end
    # end
    def destroy(&block)
      delete(self.member_path) do |response, json|
        if block
          block.call response, json
        end
      end
    end
  end
end