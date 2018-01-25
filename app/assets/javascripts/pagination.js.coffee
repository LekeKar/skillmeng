jQuery ->
  if $('#infinite-scrolling').size() > 0
    $(window).scroll ->
      more_courses_url = $('.pagination a.next_page').attr('href')
      if more_courses_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
            $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
            $.getScript more_courses_url
        return
      return
      
     