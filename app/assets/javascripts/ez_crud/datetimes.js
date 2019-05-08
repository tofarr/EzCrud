$(document).on('ready page:load', function(){
  $('.datetime').each(function(){
    var $this = $(this);
    var timestamp = $this.html();
    if(!timestamp){
      return;
    }
    timestamp = moment(timestamp);
    if(!timestamp.isValid()){
      return;
    }
    if(moment().diff(timestamp, 'days') < 1){
      $this.html(timestamp.fromNow());
    }else{
      $this.html(timestamp.format('YYYY-MM-DD HH:mm'));
    }
  });
});
