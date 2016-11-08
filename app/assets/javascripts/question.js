
$('.q_rating').on("ajax:success", (e, data, status, xhr)
question = $.parseJSON(xhr.responseText);
$('#q_rating').html(question.rating);


