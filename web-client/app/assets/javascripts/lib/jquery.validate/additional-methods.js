jQuery.validator.addMethod("username", function(value, element) {
  return /^[A-Za-z\d_\d.]+$/.test(value)
}, "Contains invalid character");