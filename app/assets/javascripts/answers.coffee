answerEditFormHandler = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()

    answer_id = $(this).data('answerId')
    edit_form = $("form#edit-answer-#{answer_id}")
    answer_body = $(".answers ##{answer_id} .answer-body")


    if edit_form.hasClass('hidden')
      $(this).text('Cancel')
    else
      $(this).text('Edit answer')
      $("form#edit-answer-#{answer_id} textarea").val(answer_body.text())


    edit_form.toggleClass('hidden')
    answer_body.toggleClass('hidden')

$(document).on('turbolinks:load', answerEditFormHandler)
