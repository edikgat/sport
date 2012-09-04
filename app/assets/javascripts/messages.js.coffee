# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
 
jQuery ->
  $('#Message_to_user_receiver_email').autocomplete
    source: $('#Message_to_user_receiver_email').data('autocomplete-source')
