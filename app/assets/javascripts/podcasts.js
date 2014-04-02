(function($) {
  $.fn.changeElementType = function(newType) {
    this.each(function() {
      var attrs = {};

      $.each(this.attributes, function(idx, attr) {
        attrs[attr.nodeName] = attr.nodeValue;
      });

      $(this).replaceWith(function() {
        return $("<" + newType + "/>", attrs).append($(this).contents());
      });
    });
  };
})(jQuery);

(function($) {

  var last_update = new Date();
  var current_epid;
  var currentTime;
  var endTime;

  $(document).ready(function() {
    // When clicking a playlist item
    $('#media-playlist tr').click(function(event) {
      event.preventDefault();

      // Switch CSS classes of playlist item we just switched FROM
      $('tr[data-epid="' + current_epid + '"]').removeClass('active');
      $('tr[data-epid="' + current_epid + '"] span.label').removeClass('label-primary label-warning label-default');
      if (currentTime < 1) {
        $('tr[data-epid="' + current_epid + '"]').addClass('info');
        $('tr[data-epid="' + current_epid + '"] span.label').addClass('label-primary').html('Unwatched');
      } else if (endTime - currentTime > 15) {
        $('tr[data-epid="' + current_epid + '"]').addClass('warning');
        $('tr[data-epid="' + current_epid + '"] span.label').addClass('label-warning').html('Watched Some');
      } else {
        $('tr[data-epid="' + current_epid + '"] span.label').addClass('label-default').html('Watched');
      }

      // Switch CSS classes of playlist item we just switched TO
      $(this).removeClass('active warning info');
      $(this).addClass('active');

      // Load episode info into various display elements
      var epid = $(this).attr('data-epid');
      $('#episode_summary').attr('data-target', '#full-entry-episode' + epid);
      $('#episode_summary div.well').html($(this).attr('data-shortsummary'));
      $('#episode_description div.modal').attr({ id: 'full-entry-episode' + epid, 'aria-labelledby': 'modal-label-episode' + epid });
      $('#episode_description h4.modal-title').attr('id', 'modal-label-episode' + epid);
      $('#episode_description h4.modal-title').html($(this).children('.episode-title').html());
      $('#episode_description div.modal-body').html($(this).attr('data-longsummary'));
      $('form').attr('id', 'new_watched_episode' + epid);
      $('form input:nth-last-child(2)').val(epid);
      $('form input:nth-last-child(1)').attr('id', 'timecode' + epid);
      $('#playlist-player').attr('data-epid', epid);
      $('#playlist-player').attr('src', $(this).attr('data-mediaurl'));

      var file_string = $(this).attr('data-mediaurl');
      var extension = file_string.match(/^[^\s]+\.([mpovgweba43]{3,4})(?:#t=\d+)?$/i)[1];
      if (extension == 'mp3' || extension == 'ogg' || extension == 'm4a') {
        if ($('#playlist-player').is('video')) {
          $('#playlist-player').changeElementType('audio');
          resetMediaEventHandlers();
        }
      } else if ($('#playlist-player').is('audio')) {
        $('#playlist-player').changeElementType('video');
        resetMediaEventHandlers();
      }

      $('#playlist-player').load();
    });

    // Load player with first video in playlist
    if ('#playlist-player') {
      $('#media-playlist tr').first().trigger('click');
      resetMediaEventHandlers();
    }

    // For multiple podcast displays (library, subscriptions) insert breaks depending on device size
    $('.podcast').each(function(index, podcast) {
      if ((index + 1) % 2 == 0) { $(podcast).after('<div class="clearfix visible-xs"></div>') };
      if ((index + 1) % 3 == 0) { $(podcast).after('<div class="clearfix visible-sm"></div>') };
      if ((index + 1) % 4 == 0) { $(podcast).after('<div class="clearfix visible-md"></div>') };
      if ((index + 1) % 6 == 0) { $(podcast).after('<div class="clearfix visible-lg"></div>') };
    });
  });

  function resetMediaEventHandlers() {
    // When starting to load a new media file, reset current time and episode id
    $('audio, video').off('loadstart').on('loadstart', function(event) {
      currentTime = 0;
      current_epid = $(this).attr('data-epid');
    });

    // When we have updated info for end and current times, update that info
    $('audio, video').off('durationchange').on('durationchange', function(event) {
      endTime = parseInt($(this)[0].duration);
      currentTime = parseInt($(this)[0].currentTime);
    });

    // When we've loaded the media file, make sure current time is correct
    $('audio, video').off('loadeddata').on('loadeddata', function(event) {
      currentTime = parseInt($(this)[0].currentTime);
    });

    // Trigger update and possibly storage of episode time information when player updates time
    $('audio, video').off('timeupdate').on('timeupdate', function(event) {
      var now = new Date();
      currentTime = parseInt($(this)[0].currentTime);

      if (endTime - currentTime < 15) {
        $('input#watched_episode_watched').val("true");
      } else {
        $('input#watched_episode_watched').val("false");
      }
      $('input#timecode' + current_epid).val(currentTime);

      // Store in database every 10 seconds, at the end of media file, or when media file is paused.
      // Also make sure we're not interacting wiht the database more than once per second
      if ( ((currentTime != 0) && (currentTime % 10 == 0) && (now - last_update > 1000)) || ($(this)[0].ended || $(this)[0].paused) ) {
        last_update = new Date();
        $('tr[data-epid="' + current_epid + '"').attr('data-mediaurl', $(this).attr('src').replace(/#t=.*/, '') + '#t=' + currentTime );
        $('#new_watched_episode' + current_epid).submit();
      }
    });
  }
})(jQuery);