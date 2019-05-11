$(document).on('ready page:load', function(){
  $('.form-upload').each(function(){
    var $this = $(this);
    var $file = $this.find('input[type=file]').on('change', fileChanged);
    if($file.data('content-type') != 'image'){
      return;
    }
    $this.find('.destroy input').click(destroyClicked);
    var img = $(this).find('img')[0];
    if(img){
      if(img.complete){
        doCroppie.call(img);
      }else{
        $(img).on('load', doCroppie).on('load', function(){
          window.setTimeout(function(){
            window.clearTimeout($(this).parents('.croppie-container').data('debounce'));
          }.bind(this), 200);
        });
      }
    }
  });

  function doCroppie(){
    var $img = $(this);
    var $field = $img.parents('.form-upload');
    var $file = $field.find('input[type=file]');
    var preferredWidth = $file.data('preferred-width') || $field.width();
    var preferredHeight = $file.data('preferred-height') || (preferredWidth * this.naturalHeight / this.naturalWidth);

    $img.croppie({
      viewport: { width: preferredWidth, height: preferredHeight },
      boundary: { width: preferredWidth, height: preferredHeight},
      enforceBoundary: false
    }).parents('.croppie-container').on('update.croppie', function(event, cropData) {
      console.log('Debouncing');
      window.clearTimeout($(this).data('debounce'))
      $(this).data('debounce', window.setTimeout(updateForm.bind(this), 400));
    });
  }

  function destroyClicked(event){
    $(this).parents('.form-upload').find('.croppie-container')[$(this).is(':checked') ? 'hide' : 'show']('slow');
  }

  function fileChanged(){
    var preview = $(this).parents('.form-upload').find('.preview');
    preview.empty();
    if (this.files && this.files[0] && isImg(this.files[0].type)) {
      var reader = new FileReader();
      reader.onload = function(event) {
        var $img = $('<img/>')
          .attr('src', event.target.result)
          .addClass('image upload-image')
          .appendTo(preview);
        doCroppie.call($img[0]);
      }
      reader.readAsDataURL(this.files[0]);
    }
  }

  function isImg(mimeType){
    return mimeType == 'image/jpg'
      || mimeType == 'image/jpeg'
      || mimeType == 'image/png'
      || mimeType == 'image/gif';
  }

  function updateForm(){
    var $upload = $(this).parents('.form-upload');
    var $input = $upload.find('.hidden_base64');
    if(!$input.length){
      var $file = $upload.find('input[type=file]');
      $input = $('<input type="hidden" name="'+$file[0].name+'" class="hidden_base64" />').appendTo($upload);
      $file[0].removeAttribute('name');
    }
    $(this).find('.cr-original-image').croppie('result', 'base64').then(function(dataImg) {
      $input.val(dataImg);
    });
  }
});
