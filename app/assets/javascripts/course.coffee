# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Scroll to top button
$(document).ready ->
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
    
    
  #Click event to scroll to top
  $('#text').keyup ->
    text_length = $(this).val().length
    $('#count_message').html text_length + ' chars'
    return
  $('#text2').keyup ->
    text_length = $(this).val().length
    $('#count_message2').html text_length + ' chars'
    return
    
    
  # Course follow button
  $('.btn-save').click ->
    $(this).find('i').toggleClass 'fa-heart-o fa-heart'
    if $(this).find('span').text() == 'Follow'
      $(this).find('span').text 'Unfollow'
    else
      $(this).find('span').text 'Follow'
    return
  return
  
  #search
$(document).ready ->
  courses = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.whitespace
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/courses/autocomplete?query=%QUERY'
      wildcard: '%QUERY')
  $('#courses_search_nav').typeahead null, source: courses
  $('#courses_search_mobile').typeahead null, source: courses
  return