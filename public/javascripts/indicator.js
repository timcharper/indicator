INDICATOR_IMAGE = "/images/indicator.gif"
function start_indicator(element) {
  element = $(element);
  if ((! element) || (element.indicating))  return;
  var indicator = new Element("img", {src: INDICATOR_IMAGE})
  
  element.indicating = true
  if (element.hasClassName("overlay_to_indicate")) {
    var enabled_inputs = element.select("input, select, button").select(function(e) { return(! e.disabled) })
    var width = (element.getDimensions().width + "px"), height = (element.getDimensions().height + "px")
    var indicator_div = new Element("div", {'class': 'overlay'}).update(indicator).setStyle({width: width, height: height, lineHeight: height});
    element.insert({before: indicator_div})
    enabled_inputs.each(function(e) { e.disable(); });
    
    element.indicating = true;
    
    element.indicator_cleanup = function() { 
      indicator_div.remove(); 
      enabled_inputs.each(function(e) { e.enable(); });
      element.indicating = false;
      element.indicator_cleanup = null;
    }
  } else if (element.hasClassName("hide_to_indicate")) {
    element.hide(); element.insert({after: indicator})
    element.indicating = true;
    element.indicator_cleanup = function() { 
      indicator.remove(); 
      element.show(); 
      element.indicator_cleanup = null; 
      element.indicating = false;
    }
  }
}

function stop_indicator(element) {
  element = $(element) 
  if (( ! element) || ( ! element.indicating)) return;
  $(element).indicator_cleanup()
}