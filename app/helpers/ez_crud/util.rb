module EzCrud::Util
  def cache_var(attr, &block)
    ret = instance_variable_get(attr)
    return ret if ret
    ret = block.call
    instance_variable_set(attr, ret) unless Rails.env.development?
    ret
  end
end
