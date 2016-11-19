$(document).on("ajax:success", '.vote-link-question', function(e, data, status, xhr) {
  question = $.parseJSON(xhr.responseText);
  $('.q_rating .value').html(question.rating);
})
$(document).on("ajax:error", '.vote-link-question', function(e, xhr, status, error) {
  message = $.parseJSON(xhr.responseText);
  $('.vote-erorr').html(message.error);
})

