# deleteQuestionAttachmentsHandler = ->
#   $('.question').on 'click', '.delete-attachment-link', (e) ->
#     e.preventDefault()
#     $('.question .attachment-control').toggleClass('hidden')

# deleteAnswerAttachmentsHandler = ->
#   $('.answers').on 'click', '.delete-attachment-link', (e) ->
#     e.preventDefault()
#     answer_id = $(this).data('answerId')
#     $("#answer-#{answer_id} .attachment-control").toggleClass('hidden')

# $(document).on('turbolinks:load', deleteQuestionAttachmentsHandler)
# $(document).on('turbolinks:load', deleteAnswerAttachmentsHandler)

