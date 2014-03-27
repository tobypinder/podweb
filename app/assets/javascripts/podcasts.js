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
  });
})(jQuery);