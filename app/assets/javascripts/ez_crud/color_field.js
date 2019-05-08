$(document).on('ready page:load', function(){
  $('.text-input').each(function(){
    if((this.name || '').toLowerCase().indexOf('color') >= 0){
      this.type = 'color';
      $(this).removeClass('text-input');
    }
  });
  $('.show-field').each(function(){
    if((this.className || '').toLowerCase().indexOf('color') >= 0){
      $(this).addClass('color-swatch').css('background-color', $(this).html()).empty('')
    }
  })
});
