$('body').on('mouseenter mouseleave','.dropdown',function(e){
  var _d=$(e.target).closest('.dropdown');_d.addClass('show');
  setTimeout(function(){
    _d[_d.is(':hover')?'addClass':'removeClass']('show');
    $('[data-toggle="dropdown"]', _d).attr('aria-expanded',_d.is(':hover'));
  },300);
});

jQuery(document).ready(function ($) {
  
  $(function() {
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
      history.pushState({}, '', e.target.hash);
    });

    var hash = document.location.hash;
    var prefix = "tab_";
    if (hash) {
      $('.nav-tabs a[href="'+hash.replace(prefix,"")+'"]').tab('show');
    }
  });
  
  $(document).on('change', '.select-format', function() {
    var target = $(this).data('target');
    var show = $("option:selected", this).data('show');
    $(target).children().addClass('hide');
    $(show).removeClass('hide');
    $('.select-topic').val('topic-all');
  });
  $(document).ready(function(){
      $('.select-format').trigger('change');
  });
  $(document).on('change', '.select-topic', function() {
    var target = $(this).data('target');
    var show = $("option:selected", this).data('show');
    $(target).children().addClass('hide');
    $(show).removeClass('hide');
    $('.select-format').val('format-all');
  });
  $(document).ready(function(){
      $('.select-topic').trigger('change');
  });
});