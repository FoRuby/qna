App.answers = App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log 'CONNECTED ANSWERS'
    console.log 'gon', gon.question_id
    @perform('follow', { question_id: gon.question_id })

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log 'RECEIVED answer', data
    if gon.user_id != data.answer.user_id
      $('.answers').append(JST['templates/answer'](answer: data.answer, rating: data.rating))
