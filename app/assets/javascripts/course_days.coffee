# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


timepick = (event) ->
  $(event).timepicker {}
  return

$(document).on 'click', '.use_suggestion', ->
  add_line1 = $(this).closest('tr').find('#address_line1_suggestion').html()
  add_line2 = $(this).closest('tr').find('#address_line2_suggestion').html()
  add_city = $(this).closest('tr').find('#city_suggestion').html()
  add_state = $(this).closest('tr').find('#state_suggestion').html()
  $(this).closest('.well').find('.address_line1_ans').find('.form-control').val add_line1.trim()
  $(this).closest('.well').find('.address_line2_ans').find('.form-control').val add_line2.trim()
  $(this).closest('.well').find('.city_ans').find('.form-control').val add_city.trim()
  $(this).closest('.well').find('.state_ans').find('.form-control').val add_state.trim()
  return
$(document).on 'click', '#collapse_link', ->
  $(this).closest('.well').find('#collapse_div').collapse 'toggle'
  return