showPrewiew = ->
  $('.reward-image').on 'change', (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader()
    reader.onload = (file) ->
      img = new Image(200)
      img.src = file.target.result
      img.src = file.target.result
      $('#image-prewiew').html(img)

    reader.readAsDataURL(image);

$(document).on('turbolinks:load', showPrewiew)
