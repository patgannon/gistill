  $(document).ready(function() {
    $('form').validate({
      errorElement: 'span',
      highlight: function(element, errorClass) {
        //$(element).addClass(errorClass);
        var parentDiv = $(element)[0].parentNode.parentNode;
        $(parentDiv).addClass(errorClass);
        //$('span.error').addClass('help-inline');
      },
      unhighlight: function(element, errorClass) {
        //$(element).removeClass(errorClass);
        var parentDiv = $(element)[0].parentNode.parentNode;
        $(parentDiv).removeClass(errorClass);
      }
    });
    //alert('len: ' + $('form').size());
  });
