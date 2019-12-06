votesHandler = ->
  $('.vote').on 'ajax:success', (e) ->
    rating = e.detail[0]['rating']
    resourceName = e.detail[0]['resourceName']
    resourceId = e.detail[0]['resourceId']

    $("##{resourceName}-#{resourceId} .vote .rating").html(rating)

$(document).on('turbolinks:load', votesHandler)
