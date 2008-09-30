class Indicator
  module InstanceMethods
    def to_dom_id(identifier)
      Array===identifier ? dom_id(*identifier) : identifier
    end
    
    def indicate_loading(identifier)
      "start_indicator('#{indicator_id(identifier)}')"
    end
    
    def indicate_complete(identifier)
      "stop_indicator('#{indicator_id(identifier)}')"
    end
  end
end

module ActionView::Helpers::PrototypeHelper
  def remote_function_with_indicator(options)
    indicate, indicate_and_update = options.delete(:indicate), options.delete(:indicate_and_update)
    identifier = indicate || indicate_and_update
    
    if identifier
      identifier = to_dom_id(identifier)
      options[:update] = identifier if indicate_and_update
      
      for op in [:loading, :complete]
        options[op] = send("indicate_#{op}", identifier) + (options[op] ? (";" + options[op].to_s) : "")
      end
    end
    
    remote_function_without_indicator(options)
  end
  
  alias_method_chain :remote_function, :indicator
end
