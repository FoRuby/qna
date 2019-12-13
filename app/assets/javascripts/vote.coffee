votesHandler = ->
  $('body').on 'ajax:success', (e) ->
    votableName = e.detail[0]['votable']['name']
    votableId = e.detail[0]['votable']['id']
    rating =  e.detail[0]['votable']['rating']

    $("##{votableName}-#{votableId} .vote .rating").html(rating)

$(document).on('turbolinks:load', votesHandler)
