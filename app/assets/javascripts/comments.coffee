commentAddCommentButton = ->
  $('body').on 'click', '.add-comment-link', (e) ->
    e.preventDefault()

    commentable_id = $(this).data('commentableId')
    commentable_type = $(this).data('commentableType')
    new_comment_form = $("##{commentable_type}-#{commentable_id} .new-comment-form")

    new_comment_form > $('textarea#comment_body').val('')
    new_comment_form.toggleClass('hidden')


$(document).on('turbolinks:load', commentAddCommentButton)
