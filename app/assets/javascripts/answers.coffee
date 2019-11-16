answerEditFormHandler = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()

    answer_id = $(this).data('answerId')
    edit_form = $("form#edit-answer-#{answer_id}")
    answer_body = $("#answer-#{answer_id} .answer-body")

    if edit_form.hasClass('hidden')
      $(this).text('Cancel')
    else
      $(this).text('Edit answer')
      $("form#edit-answer-#{answer_id} #answer_body").val(answer_body.text())
      $('.edit-answer-errors').empty()

    edit_form.toggleClass('hidden')
    answer_body.toggleClass('hidden')

bestAnswerSelectorHandler = ->
  $('.question').on 'click', '.edit-best-answer-link', (e) ->
    e.preventDefault()
    $('.edit-best-answer-icon').toggleClass('hidden')
    $('.best-answer-icon').toggleClass('hidden')

$(document).on('turbolinks:load', answerEditFormHandler)
$(document).on('turbolinks:load', bestAnswerSelectorHandler)
