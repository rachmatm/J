jQuery.validator.addMethod("username", function(value, element) {
  return /^[A-Za-z0-9.\d_]+$/.test(value)
}, "Contains invalid character");