answerEditFormHandler = ->
  $('.answers').on 'click', '.edit-answer-link', (event) ->
    event.preventDefault()

    answer_id = $(this).data('answerId')
    answer_edit_form = $("form#edit-answer-#{answer_id}")
    answer_content = $("#answer-#{answer_id} .answer-content")
    answer_body = $("#answer-#{answer_id} .answer-body")

    if answer_edit_form.hasClass('hidden')
      $(this).text('Cancel')
    else
      $(this).text('Edit answer')
      #при отмене в форму редактирования возвращает текст ответа
      $("#answer_body").val(answer_body.text())
      #при отмене очищаем форму линков
      $("#answer-#{answer_id} .new-link-form input").val('')
      #при отмене очищается форма с ошибками
      $('.edit-answer-errors').empty()

    answer_edit_form.toggleClass('hidden')
    answer_content.toggleClass('hidden')

bestAnswerSelectorHandler = ->
  $('.question').on 'click', '.edit-best-answer-link', (event) ->
    event.preventDefault()
    $('.edit-best-answer-icon').toggleClass('hidden')
    $('.best-answer-icon').toggleClass('hidden')

$(document).on('turbolinks:load', answerEditFormHandler)
$(document).on('turbolinks:load', bestAnswerSelectorHandler)
