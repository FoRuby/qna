App.cable.subscriptions
  .create { channel: "AnswersChannel", question_id: gon.question_id },

  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log 'RECEIVED answer', data
    # if gon.question_id == data.answer.question_id
    if gon.user_id != data.answer.user_id
      $('.answers').append(JST['templates/answer'](
        answer: data.answer,
        links: data.links,
        rating: data.rating,
        attachments: data.attachments)
      )
      $('.flash-messages').html(JST['templates/message'](success: data.success))
