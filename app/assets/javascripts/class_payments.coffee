# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'click', '.fill_bank_details', ->
  bank_name = $(this).closest('tr').find('#bank_name_suggestion').html()
  account_number = $(this).closest('tr').find('#account_number_suggestion').html()
  account_name = $(this).closest('tr').find('#account_name_suggestion').html()
  refund_instruction = $(this).closest('tr').find('#refund_instruction_suggestion').html()
  payment_instruction = $(this).closest('tr').find('#payment_instruction_suggestion').html()
  $(this).closest('.bank_details').find('.bank_name_ans').find('.form-control').val bank_name.trim()
  $(this).closest('.bank_details').find('.account_number_ans').find('.form-control').val account_number.trim()
  $(this).closest('.bank_details').find('.account_name_ans').find('.form-control').val account_name.trim()
  $(this).closest('.bank_details').find('.refund_instruction_ans').find('.form-control').val refund_instruction.trim()
  $(this).closest('.bank_details').find('.payment_instruction_ans').find('.form-control').val payment_instruction.trim()
return