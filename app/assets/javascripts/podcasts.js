(function($) {
  $(document).ready(function() {
    last_update = new Date();
    $('audio, video').on('timeupdate', function(event) {
      currentTime = parseInt($(this)[0].currentTime);
      epid = $(this).data('epid');
      now = new Date();
      $('#timecode' + epid).val(currentTime);
      if ( (currentTime != 0) && (currentTime % 10 == 0) && (now - last_update > 1000)) {
        last_update = new Date();
        $('#new_watched_episode' + epid).submit();
      }
    });

    $('.podcast').each(function(index, podcast) {
      if ((index + 1) % 2 == 0) { $(podcast).after('<div class="clearfix visible-xs"></div>') };
      if ((index + 1) % 3 == 0) { $(podcast).after('<div class="clearfix visible-sm"></div>') };
      if ((index + 1) % 4 == 0) { $(podcast).after('<div class="clearfix visible-md"></div>') };
      if ((index + 1) % 6 == 0) { $(podcast).after('<div class="clearfix visible-lg"></div>') };
    });
  });
})(jQuery);