$(document).on('ready page:load', function(){
  $('.text-input.datetime').flatpickr({
    enableTime: true,
    dateFormat: "Y-m-d H:i",
  });
});
