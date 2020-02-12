deleteLink = ->
  $('.links-delete').on 'click', '.delete-icon', (event) ->
    link_id = $(this).data('linkId')
    linkable = "##{$(this).data('linkableType')}-#{$(this).data('linkableId')}"

    $(document).on 'ajax:success', (event) ->
      $(".links #link-#{link_id}").remove()
      $(".links-delete #link-#{link_id}").remove()
      if $("#{linkable} .links ").find('.link').length is 0
        $("#{linkable} .links").remove()
        $("#{linkable} .links-delete").remove()

$(document).on('turbolinks:load', deleteLink)
