$(document).on('ready page:load', function(){
  $('textarea.text-area').each(function(){
    var $this = $(this);
    if($this.data('markdown')){
      new SimpleMDE({ element: this });
    }
  });
});
