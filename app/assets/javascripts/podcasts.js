(function($) {
  $(document).ready(function() {
    $('audio, video').on('timeupdate', function(event) {
      currentTime = parseInt($(this)[0].currentTime);
      epid = $(this).data('epid');
      $('#timecode' + epid).val(currentTime);
      if ( (currentTime % 10 == 0) && (currentTime != 0) ) {
        setTimeout(function(){ $('#new_watched_episode' + epid).submit(); }, 1000);
      }
    });
  });
})(jQuery);