$(document).ready(function() {
	//alert('path = ' + window.location.pathname);
	$('li').removeClass('active');
	if (window.location.pathname == "/") {
	    $('#home_link').addClass('active');
        }
	if (window.location.pathname == "/books") {
	    $('#my_books_link').addClass('active');
        }
	if (window.location.pathname == "/books/new") {
	    $('#create_link').addClass('active');
        }
});
