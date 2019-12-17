App.cable.subscriptions
  .create { channel: "CommentsChannel", question_id: gon.question_id },
  connected: ->
    # Called when the subscription is ready for use on the server
  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    return if gon.user_id is data.comment.user_id

    type = data.comment.commentable_type.toLowerCase()
    id = data.comment.commentable_id
    $("##{type}-#{id} .comments")
      .append(JST['templates/comment'](comment: data.comment))
    $('.flash-messages').html(JST['templates/message'](success: data.success))
