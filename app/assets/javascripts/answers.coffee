answerEditFormHandler = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    console.log answer_id
    $("form#edit-answer-#{answer_id}").removeClass('hidden')

$(document).on('turbolinks:load', answerEditFormHandler)
