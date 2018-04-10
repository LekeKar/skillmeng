# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Scroll to top button


$(document).ready ->
  #search
  courses = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/courses/autocomplete?query=%QUERY'
      wildcard: '%QUERY')
  $('#courses_search_nav').typeahead null, source: courses
  $('#courses_search_mobile').typeahead null, source: courses

  #Check to see if the window is top if not then display button
  $(window).scroll ->
    if $(this).scrollTop() > 100
      $('.scrollToTop').fadeIn()
    else
      $('.scrollToTop').fadeOut()
    return
    
  #Click event to scroll to top
  $('.scrollToTop').click ->
    $('html, body').animate { scrollTop: 0 }, 800
    false
    
    
  #Character counter
  $('#text').keyup ->
    text_length = $(this).val().length
    max_length = $('#count_message').data('value')
    $('#count_message').html text_length + ' /' + max_length
    return
    
  $('#text2').keyup ->
    text_length = $(this).val().length
    max_length = $('#count_message2').data('value')
    $('#count_message2').html text_length + '/'+ max_length
    return
    
    
  # Course follow button
  $('.btn-save').click ->
    $(this).toggleClass 'btn-visitor-o btn-visitor'
    $(this).find('i').toggleClass 'fa-heart-o fa-heart'
    if $(this).find('span').text() == 'Interested'
      $(this).find('span').text 'I\'m interested'
    else
      $(this).find('span').text 'Interested'
    return
  return
return
  
