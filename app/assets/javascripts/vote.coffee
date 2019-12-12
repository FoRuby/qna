votesHandler = ->
  $('.vote').on 'ajax:success', (e) ->
    console.log 'a am voteHandler'
    votableName = e.detail[0]['votable']['name']
    votableId = e.detail[0]['votable']['id']
    rating =  e.detail[0]['votable']['rating']
    console.log votableName
    console.log votableId
    console.log rating

    $("##{votableName}-#{votableId} .vote .rating").html(rating)

$(document).on('turbolinks:load', votesHandler)
$(document).on 'turbolinks:load', (e) ->
  $('.vote').on 'ajax:complete', (e) ->
    console.log e
