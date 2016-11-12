
$(document).on("ajax:success", function(e, data, status, xhr) {
  question = $.parseJSON(xhr.responseText);
  $('.q_rating .value').html(question.rating);
})
$(document).on("ajax:error", function(e, xhr, status, error) {
  message = $.parseJSON(xhr.responseText);
  $('.vote-erorr').html(message.error);
})
