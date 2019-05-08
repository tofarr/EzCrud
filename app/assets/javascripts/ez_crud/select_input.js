$(document).on('ready page:load', function(){
  $('select.select-input').each(function(){
    var $this = $(this);
    var attrs = {};
    var store = $this.data('store');
    if(store){
      var excludeIds = $this.data('exclude-ids') || [];
      attrs.ajax = {
        url: '/' + store + '.json',
        data: function(params){
          var ret = {};
          if(params.term){
            ret.search = {
              query: params.term
            }
          }
          return ret;
        },
        processResults: function (data) {
          var results = data.models.map(function(result){
            return {
              id: result.id,
              text: result.identifier || result.title || result.username
            };
          });
          if(excludeIds.length){
            results = results.filter(function(result){
              return excludeIds.indexOf(result.id) < 0;
            });
          }
          return { results: results };
        }
      };
      var allowClear = ($this.data('allow-clear') == "true");
      if(allowClear){
        attrs.placeholder = "No Value";
        attrs.allowClear = true;
      }
      var params = $this.data('params');
      if(params){
        attrs.data = params;
      }
    }
    $this.select2(attrs);
  });
});
