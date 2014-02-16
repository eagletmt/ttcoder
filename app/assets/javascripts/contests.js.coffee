# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#user_name.typeahead').typeahead name: 'username', valueKey: 'name', remote: '/users.json?q=%QUERY'
