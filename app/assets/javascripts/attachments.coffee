deleteAttachmentsHandler = ->
  $('.question').on 'click', '.delete-attachment-link', (e) ->
    e.preventDefault()
    $('.attachmen-control').toggleClass('hidden')

$(document).on('turbolinks:load', deleteAttachmentsHandler)

