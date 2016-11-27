# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App.cable.subscriptions.create("CommentsChannel", {
  connected: ->
    question_id = $(".question").data("questionId")
    if question_id
      @perform "follow", question_id: question_id
    else
      @perform 'unfollow'
  ,
  received: (data) ->
    data = $.parseJSON(data)
    $('#comments_list_for_' + data['commentable_type'] + '_' + data['commentable_id']).append(JST["templates/comment"](comment: data.comment))
   
})