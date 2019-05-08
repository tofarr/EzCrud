$(document).on('ready page:load', function(){
  $('.paginator').each(function(){
    var $this = $(this);
    $this.find('.go-button').hide();
    $this.find('.page-select').change(function(){
      $(this).parent('form').submit();
    });
  });
});
