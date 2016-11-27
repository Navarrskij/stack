$(document).on("click", "[data-behaviour='new_comment_form_link']", function(e, data, status, xhr) {
	e.preventDefault();
	$("#" + $(e.target).data('target')).removeClass('hidden');
})
