App.cable.subscriptions
  .create { channel: "CommentsChannel", question_id: gon.question_id },
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log 'connected to comments'
  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log 'RECEIVED comment', data
    if gon.question_id == data.answer.question_id
      if gon.user_id != data.comment.user_id
        # $('.answers').append(JST['templates/answer'](
        #   answer: data.answer,
        #   links: data.links,
        #   rating: data.rating,
        #   attachments: data.attachments)
        # )
        $('.flash-messages').html(JST['templates/message'](success: data.success))
