$(document).on('ready page:load', function(){
  $('.json-input').each(function(){
    var $input = $(this);
    if($input.parents('.json-tabs').length){
      return;
    }
    var $parent = $input.parent();
    $input.remove();
    $parent.append($('<div class="json-tabs"><div class="tab-header"><button type="button" data-tab=".form-tab" class="tab active">Form</button><button type="button" data-tab=".json-tab" class="tab">JSON</button></div><div class="tab-contents"><div class="tab-content form-tab"></div><div style="display:none" class="tab-content json-tab"></div></div></div>'));
    if(!$input.data('tabs')){
      $parent('.tab-header').hide();
    }
    $parent.find('.json-tab').append($input);
    $parent.find('.tab-header button').click(tabClicked);
    $input.on('change', function(){
      buildForm($(this).parents('.json-tabs'));
    });
    buildForm($parent.find('.json-tabs'));
  });

  function tabClicked(){
    var $button = $(this);
    if($button.hasClass('active')){
      return;
    }
    var $tabs = $button.parents('.json-tabs');
    $tabs.find('.tab-header button').removeClass('active');
    $button.addClass('active');
    $tabs.find('.tab-content:visible').hide('fast', function(){
      $tabs.find($button.data('tab')).show('fast');
    });
  }

  function buildForm($tabs){
    var $json = $tabs.find('.json-input');
    var json = JSON.parse($json.val());
    var open = $json.data('open');
    $tabs.find('.form-tab').empty();
    $tabs.find('.form-tab').append(buildJsonForm(json));
    if(!open){
      $tabs.addClass('locked-down').find('.button,select').hide();
      $tabs.find('.key').prop('readonly', true);
    }
  }

  function type(json){
    if(json == null){
      return 'null';
    } else if(json instanceof Array){
      return 'array';
    } else{
      return typeof json;
    }
  }

  function buildJsonForm(json){
    var $container = $('<div class="json-field"><select class="json-type"></select><div class="json-value"></div></div>');
    var select = $container.find('select')[0];
    var options = ['array','boolean','null','number','object','string'];
    for(var i = 0; i < options.length; i++){
      select.options[i] = new Option(options[i]);
    }
    select.value = type(json);
    $(select).on('change', typeChanged);
    $container.find('.json-value').append(buildInput(json));
    return $container;
  }

  function typeChanged(){
    var $this = $(this);
    var type = $this.val();
    var $jsonValue = $this.parent().children('.json-value').first();
    value = null;
    if(type == 'array'){
      value = [];
    }else if(type == 'object'){
      value = {};
    }else if(type == 'boolean'){
      value = false;
    }else if(type == 'number'){
      value = 0;
    }else if(type == 'string'){
      value = '';
    }
    function callback(){
      $jsonValue.empty();
      var $input = buildInput(value);
      $jsonValue.append($input);
      buildJson($jsonValue.parents('.json-tabs'))
      $jsonValue.children().show('fast');
    }
    if($jsonValue.children().length){
      $jsonValue.children().hide('fast', callback);
    }else{
      callback();
    }
  }

  function buildInput(json){
    switch(type(json)){
      case 'array':
        var $items = $('<div class="items"></div>');
        for(var i = 0; i < json.length; i++){
          $items.append(buildArrayItem(json[i]));
        }
        var $container = $('<div class="array"></div>').append($items);
        $container.append($('<button class="add button" type="button">+</button>').click(addArrayMapping));
        return $container;
      case 'boolean':
        return $('<input type="checkbox" class="boolean" />').prop('checked', json).click(formChanged);
      case 'null':
        return;
      case 'number':
        return $('<input type="number" class="number" />').change(formChanged).val(json);
      case 'object':
        var $items = $('<div class="items"></div>');
        for(var key in json){
          $items.append(buildObjectItem(key, json[key]));
        }
        var $container = $('<div class="object"></div>').append($items);
        $container.append($('<button class="add button" type="button">+</button>').click(addObjectMapping));
        return $container;
      case 'string':
        return $('<input type="text" class="string" />').change(formChanged).val(json);
    }
  }

  function buildArrayItem(json){
    var $item = $('<div class="item"><button type="button" class="remove button">X</button><button type="button" class="move-up button">&uarr;</button></div>');
    $item.find('button.remove').click(removeItem);
    $item.find('button.move-up').click(moveUp);
    $item.prepend(buildJsonForm(json));
    return $item;
  }

  function buildObjectItem(key, value){
    var $item = $('<div class="item"><input type="text" class="key" /><button type="button" class="remove button">X</button></div>');
    $item.find('input').val(key);
    $item.find('button').click(removeItem);
    $item.append(buildJsonForm(value));
    $item.children('.key').change(formChanged);
    return $item;
  }

  function moveUp(){
    var $item = $(this).parents('.item').first();
    var $prev = $item.prev();
    $prev.before($item.detach());
    buildJson($item.parents('.json-tabs'))
  }

  function removeItem(){
    var $tabs = $(this).parents('.json-tabs').first();
    $(this).parents('.item').first().hide('fast', function(){
      $(this).remove();
      buildJson($tabs)
    });
  }

  function addArrayMapping(){
    debugger;
    var $items = $(this).parents('.array').first().find('.items').first();
    var $item = $items.find('.item').first();
    if($item.length){
      $item = cloneWithSelectValues($item);
    }else{
      $item = buildArrayItem("");
    }
    $items.append($item.hide());
    $item.show('fast');
    buildJson($items.parents('.json-tabs').first());
  }

  function addObjectMapping(){
    var $items = $(this).parents('.object').first().find('.items').first();
    var $item = $items.find('.item').first();
    if($item.length){
      $item = cloneWithSelectValues($item);
    }else{
      $item = buildObjectItem("", "");
    }
    $items.append($item.hide());
    $item.show('fast');
    buildJson($items.parents('.json-tabs').first());
  }

  function cloneWithSelectValues($item){
    var ret = $item.clone(true);
    var s1 = $item.find('select');
    var s2 = ret.find('select');
    for(var s = 0; s < s1.length; s++){
      s2[s].value = s1[s].value;
    }
    return ret;
  }

  function formChanged(){
    buildJson($(this).parents('.json-tabs').first());
  }

  function buildJson($tabs){
    var json = jsonFromField($tabs.find('.form-tab').children('.json-field'));
    $tabs.find('.json-input').val(JSON.stringify(json, null, 2));
  }

  function jsonFromField($field){
    var type = $field.children('.json-type').val();
    switch(type){
      case 'array':
        var items = $field.find('.items').first().children();
        var ret = [];
        for(var i = 0; i < items.length; i++){
          ret.push(jsonFromField($(items[i]).find('.json-field').first()));
        }
        return ret;
      case 'boolean':
        return $field.find('.boolean').is(':checked');
      case 'null':
        return null;
      case 'number':
        return parseFloat($field.find('.number').val());
      case 'object':
        var items = $field.find('.items').first().children();
        var ret = {};
        for(var i = 0; i < items.length; i++){
          var $item = $(items[i]);
          var key = $item.children('.key').val();
          var value = jsonFromField($item.find('.json-field').first());
          ret[key] = value;
        }
        return ret;
      case 'string':
        return $field.find('.string').val();
    }
  }
});
