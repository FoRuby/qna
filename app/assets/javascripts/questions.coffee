questionEditFormHandler = ->
  $('.question').on 'click', '.edit-question-link', (event) ->
    event.preventDefault()

    if $(".edit-question-form form").hasClass('hidden')
      $(this).text('Cancel')
    else
      $(this).text('Edit question')
      $('#question_title').val($('.question-title').text())
      $('#question_body').val($('.question-body').text())
      $('.question .new-link-form input').val('')
      $('.edit-question-errors').empty()

    $('.edit-question-form form').toggleClass('hidden')
    $('.question-content').toggleClass('hidden')


$(document).on('turbolinks:load', questionEditFormHandler)
