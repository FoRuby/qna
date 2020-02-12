votesHandler = ->
  $('.vote').on 'ajax:success', (event) ->
    votableName = event.detail[0]['votable']['name']
    votableId = event.detail[0]['votable']['id']
    rating =  event.detail[0]['votable']['rating']

    $("##{votableName}-#{votableId} .vote .rating").html(rating)

$(document).on('turbolinks:load', votesHandler)
