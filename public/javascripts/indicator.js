INDICATOR_IMAGE = "/images/indicator.gif"
function start_indicator(element) {
  element = $(element);
  if (! element) return;
  
  var indicator = new Element("img", {src: INDICATOR_IMAGE})
  if (element.hasClassName("overlay_to_indicate")) {
    var enabled_inputs = element.select("input, select, button").select(function(e) { return(! e.disabled) })
    var width = element.getDimensions().width + "px", height = element.getDimensions().height + "px"
    var indicator_div = new Element("div", {class: 'overlay'}).update(indicator).setStyle({width: width, height: height, "lineHeight": height });
    element.insert({before: indicator_div})
    enabled_inputs.each(function(e) { e.disable(); });
    element.indicator_done = function() { 
      indicator_div.remove(); 
      enabled_inputs.each(function(e) { e.enable(); });
      element.indicator_done = null; 
    }
  } else if (element.hasClassName("hide_to_indicate")) {
    element.hide(); element.insert({after: indicator})
    element.indicator_done = function() { indicator.remove(); element.show(); element.indicator_done = null; }
  }
}

function stop_indicator(element) {
  $(element).indicator_done && $(element).indicator_done()
}