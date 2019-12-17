deleteAttachment = ->
  $('.attachments-delete').on 'click', '.delete-icon', (event) ->
    attachment_id = $(this).data('attachmentId')
    attachable = "##{$(this).data('attachableType')}-#{$(this).data('attachableId')}"

    $(document).on 'confirm:complete', (event) ->
      if event.detail[0]
        $(".attachments #attachment-#{attachment_id}").remove()
        $(".attachments-delete #attachment-#{attachment_id}").remove()
        if $("#{attachable}").find('.attachment').length is 0
          $("#{attachable} .attachments").remove()
          $("#{attachable} .attachments-delete").remove()

$(document).on('turbolinks:load', deleteAttachment)
