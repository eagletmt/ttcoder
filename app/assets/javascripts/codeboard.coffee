# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class Codeboard
  constructor: (@url, @board) ->
    @board.on('blur', =>
      @post()
    )

  get: ->
    $.ajax(
      type: 'GET'
      url: @url
    ).done (json) =>
      if !@board.is(':focus')
        @board.val(json.source)

  post: ->
    $.ajax(
      type: 'POST'
      url: @url
      data:
        source: @board.val()
    )

@controlCodeboard = (url, codeboard) ->
  b = new Codeboard(url, codeboard)
  setInterval(->
    b.get()
  , 5000
  )
