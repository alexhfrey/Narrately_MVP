clientSideValidations.callbacks.element.pass = function(element, callback) {
  // Take note how we're passing the callback to the hide() 
  // method so it is run after the animation is complete.
  callback();
  element.parent().setAttribute("class", "control-group success");
}
