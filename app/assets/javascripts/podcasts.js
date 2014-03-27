(function($) {
  $(document).ready(function() {
    $('audio, video').on('timeupdate', function(event) {
      currentTime = parseInt($(this)[0].currentTime);
      epid = $(this).data('epid');
      $('#timecode' + epid).val(currentTime);
      if ( (currentTime % 30 == 0) && (currentTime != 0) ) {
        $('#new_watched_episode' + epid).submit();
      }
    });
  });
})(jQuery);