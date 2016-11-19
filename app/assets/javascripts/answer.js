$(document).on("ajax:success", '.vote-link-answer', function(e, data, status, xhr) {
  answer = $.parseJSON(xhr.responseText);
  $("#" + $(e.target).data('container')).find('.a-value').html(answer.rating);
})
$(document).on("ajax:error", '.vote-link-answer', function(e, xhr, status, error) {
	message = $.parseJSON(xhr.responseText);
  $("#" + $(e.target).data('container')).find('.a-vote-erorr').html(message.error);
})