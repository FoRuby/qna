questionEditFormHandler = ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()

    if $(".edit-question-form form").hasClass('hidden')
      $(this).text('Cancel')
    else
      $(this).text('Edit question')
      $('#question_title').val($('.question-title').text())
      $('#question_body').val($('.question-body').text())
      $('.edit-question-errors').empty()


    $('.edit-question-form form').toggleClass('hidden')
    $('.question-title').toggleClass('hidden')
    $('.question-body').toggleClass('hidden')

$(document).on('turbolinks:load', questionEditFormHandler)
