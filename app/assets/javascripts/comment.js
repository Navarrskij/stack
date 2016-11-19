$(document).on("click", '#new_comment_link', function(e, data, status, xhr) {
	e.preventDefault();
	$('#new_comment_form').removeClass('hidden')
})

$(document).on("click", '#new_comment2_link', function(e, data, status, xhr) {
	e.preventDefault();
	$('#new_comment_form2').removeClass('hidden')
})