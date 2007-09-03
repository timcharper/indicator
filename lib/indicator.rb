class Indicator
  module InstanceMethods
    def to_dom_id(identifier)
      Array===identifier ? dom_id(identifier[0], identifier[1]) : identifier
    end
    
    def indicator_id(identifier)
      "#{to_dom_id(identifier)}_indicator"
    end
  
    def indicator(identifier)
      image_tag "indicator.gif", :id => indicator_id(identifier), :style => "display:none"
    end  
    
    # returns the options for an ajax call to hide/show indicator and div element.  Use in conjunction with indicated_div for best results
    # Example
    # 
    # 
    def indicated_update(record, prefix=nil, options={})
      indicated_update_options(record, prefix).merge(options)
    end
    
    alias :indicated :indicated_update
      
    def show_indicator(identifier)
      "$('#{indicator_id(identifier)}').show();"
    end
    
    def hide_indicator(identifier)
      "$('#{indicator_id(identifier)}').hide();"
    end
    
    def indicate_loading(identifier)
      identifier = to_dom_id(identifier)
      "#{show_indicator(identifier)} Element.hide( '#{identifier}' );"
    end
    
    def indicate_complete(identifier)
      identifier = to_dom_id(identifier)
      "#{hide_indicator(identifier)} Element.show( '#{identifier}' );"
    end
    
    def indicated_tag(tag, identifier, *args, &block)
      identifier = to_dom_id(identifier)
      content = args.first.is_a?(Hash) ? "" : args.shift
      options = args.first.is_a?(Hash) ? args.shift : {}

      output = indicator(identifier)
      output << if block_given? 
        content_tag(tag, capture(&block), options.merge(:id => identifier)) 
      else
        content_tag(tag, content, options.merge(:id => identifier) )
      end
      
      concat output, block.binding if block_given?
      output
    end
    
    def indicated_div(identifier, *args, &block)
      indicated_tag(:div, identifier, *args, &block)
    end
    
    def indicated_span(identifier, *args, &block)
      indicated_tag(:span, identifier, *args, &block)
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
