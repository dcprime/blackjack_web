$(document).ready(function() {

  $(document).on('click', '#hit_form button', function() {

    $.ajax({
      type: 'POST',
      url: '/hit',
      // data: {}
    }).done(function(msg) {
      $('#game').replaceWith(msg);
    });
    return false;
  });

  $(document).on('click', '#stay_form button', function() {

    $.ajax({
      type: 'POST',
      url: '/stay',
      // data: {}
    }).done(function(msg) {
      $('#game').replaceWith(msg);
    });
    return false;
  });

  $(document).on('click', '#dealer_hit_form button', function() {

    $.ajax({
      type: 'POST',
      url: '/dealer_hit',
      // data: {}
    }).done(function(msg) {
      $('#game').replaceWith(msg);
    });
    return false;
  });

});
