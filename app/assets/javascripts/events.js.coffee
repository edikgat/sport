# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#Search_title123').autocomplete
    source: $('#Search_title123').data('autocomplete-source')

  $('#Search_title1234').autocomplete
    source: $('#Search_title1234').data('autocomplete-source')
