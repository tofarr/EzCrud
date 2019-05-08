$(document).on('ready page:load', function(){
  $('.text-input').each(function(){
    if((this.name || '').toLowerCase().indexOf('color') >= 0){
      this.type = 'color';
      $(this).removeClass('text-input');
    }
  });
});
