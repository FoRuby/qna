App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log 'CONNECTED'
    @perform 'follow'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    # console.log 'RECEIVED', data
    console.log data
    # $('.questions').append(data)
    $('.questions').append("TESTTESTTESTTESTTESTTESTTESTTEST")
