(function($) {

})(jQuery);

(function($) {
  $(document).ready(function() {
    var last_update = new Date();
    var current_epid;
    var currentTime;
    var endTime;

    if ('#playlist-player') {
      setPlayerEpisode($('#media-playlist tr').first());
      $('#media-playlist tr').click(function(event) {
        event.preventDefault();
        $('tr[data-epid="' + current_epid + '"]').removeClass('active');
        $('tr[data-epid="' + current_epid + '"] span.label').removeClass('label-primary label-warning label-default');
        if (currentTime < 1) {
          $('tr[data-epid="' + current_epid + '"]').addClass('info');
          $('tr[data-epid="' + current_epid + '"] span.label').addClass('label-primary').html('Unwatched');
        } else if (endTime - currentTime > 15) {
          $('tr[data-epid="' + current_epid + '"]').addClass('warning');
          $('tr[data-epid="' + current_epid + '"] span.label').addClass('label-warning').html('Some Watched');
        } else {
          $('tr[data-epid="' + current_epid + '"] span.label').addClass('label-default').html('Watched');
        }
        setPlayerEpisode($(this));
      });
    }

    $('.podcast').each(function(index, podcast) {
      if ((index + 1) % 2 == 0) { $(podcast).after('<div class="clearfix visible-xs"></div>') };
      if ((index + 1) % 3 == 0) { $(podcast).after('<div class="clearfix visible-sm"></div>') };
      if ((index + 1) % 4 == 0) { $(podcast).after('<div class="clearfix visible-md"></div>') };
      if ((index + 1) % 6 == 0) { $(podcast).after('<div class="clearfix visible-lg"></div>') };
    });

    $('audio, video').on('loadstart', function(event) {
      currentTime = 0;
      current_epid = $(this).attr('data-epid');
    });

    $('audio, video').on('durationchange', function(event) {
      endTime = parseInt($(this)[0].duration);
      currentTime = parseInt($(this)[0].currentTime);
    });

    $('audio, video').on('loadeddata', function(event) {
      currentTime = parseInt($(this)[0].currentTime);
    });

    $('audio, video').on('timeupdate', function(event) {
      var now = new Date();
      currentTime = parseInt($(this)[0].currentTime);
      setTimeFormInfo(currentTime, endTime, current_epid);

      if ( ((currentTime != 0) && (currentTime % 10 == 0) && (now - last_update > 1000)) || ($(this)[0].ended || $(this)[0].paused) ) {
        last_update = new Date();
        $('tr[data-epid="' + current_epid + '"').attr('data-mediaurl', $(this).attr('src').replace(/#t=.*/, '') + '#t=' + currentTime );
        $('#new_watched_episode' + current_epid).submit();
      }
    });
  });

  function setPlayerEpisode(episodeLink) {
    var epid = episodeLink.attr('data-epid');

    episodeLink.removeClass('warning info');
    episodeLink.addClass('active');

    $('#episode_summary').attr('data-target', '#full-entry-episode' + epid);
    $('#episode_summary div.well').html(episodeLink.attr('data-shortsummary'));

    $('#episode_description div.modal').attr({
      id: 'full-entry-episode' + epid,
      'aria-labelledby': 'modal-label-episode' + epid
    });
    $('#episode_description h4.modal-title').attr('id', 'modal-label-episode' + epid);
    $('#episode_description h4.modal-title').html(episodeLink.children('.episode-title').html());
    $('#episode_description div.modal-body').html(episodeLink.attr('data-longsummary'));

    $('form').attr('id', 'new_watched_episode' + epid);
    $('form input:nth-last-child(2)').val(epid);
    $('form input:nth-last-child(1)').attr('id', 'timecode' + epid);

    $('#playlist-player').attr('data-epid', epid);
    $('#playlist-player').attr('src', episodeLink.attr('data-mediaurl'));
    $('#playlist-player').load();
  }

  function setTimeFormInfo(currentTime, endTime, current_epid) {
    if (endTime - currentTime < 15) {
      $('input#watched_episode_watched').val("true");
    } else {
      $('input#watched_episode_watched').val("false");
    }
    $('input#timecode' + current_epid).val(currentTime);
  }

  $.fn.changeElementType = function(newType) {
    var attrs = {};

    $.each(this[0].attributes, function(idx, attr) {
      attrs[attr.nodeName] = attr.nodeValue;
    });

    this.replaceWith(function() {
      return $("<" + newType + "/>", attrs).append($(this).contents());
    });
  };
})(jQuery);