$(document).on("ajax:success", function(e, data, status, xhr) {
  answer = $.parseJSON(xhr.responseText);
  $('.a-rating .a-value').html(answer.rating);
})
$(document).on("ajax:error", function(e, xhr, status, error) {
	message = $.parseJSON(xhr.responseText);
  $('.a-vote-erorr').html(message.error);
  })