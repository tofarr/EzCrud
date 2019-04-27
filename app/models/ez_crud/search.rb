
class EzCrud::Search

  ATTRS = [:query, :page_size, :page_index, :max_id, :ids, :sort_order]
  attr_accessor(*ATTRS)

  def initialize(hash = {})
    initializeFromSymbols(hash = hash.present? ? hash.as_json.deep_symbolize_keys : {})
  end

  def initializeFromSymbols(hash)
    ATTRS.each { |a| send("#{a}=", hash[a]) }
    self.ids.reject!{|v| v.empty? }.map{|v| v.to_i } if ids.present?
    if page_size.present?
      self.page_size = page_size.to_i
      raise ApplicationController::BadRequest.new() if (page_size <= 0)
      raise ApplicationController::BadRequest.new() if (hash[:enforce_limit] != false) && (page_size > Rails.configuration.max_page_size)
    end
    self.ids = ids.reject{|v| v.empty? }.map{|v| v.to_i } if ids.present?
    self.page_size = page_size.present? ? page_size.to_i : Rails.configuration.max_page_size
    self.page_index = page_index.to_i if page_index.present?
  end

  def search(results)
    results = apply_query(results)
    results = apply_sort_orders(results)
    results = apply_paging(results)
  end

  def count(results)
    results = apply_query(results)
    results.count
  end

  def apply_ids(results)
    results = results.where(id: ids) if ids.present?
    results
  end

  def filter_attrs
    []
  end

  def apply_query(results)
    if query.present?
      raise ApplicationController::BadRequest.new() if filter_attrs.blank?
      like = "%#{query}%"
      results = filter_attrs.inject(results) do |results, filter_attr|
        results.where("#{filter_attr} like ?", like)
      end
    end
    results = results.where("id < ?", max_id) if max_id.present?
    results
  end

  def permitted_orders
    filter_attrs + [:id, :created_at, :updated_at]
  end

  def apply_sort_orders(results)
    if sort_order.blank?
      results
    elsif sort_order.is_a?(String)
      apply_sort_order(results, sort_order, false)
    else
      sort_order.inject(results) do |results, k, v|
        apply_sort_order(results, k, v)
      end
    end
  end

  def apply_sort_order(results, attr, desc)
    attr = attr.to_sym
    desc = desc.to_sym == :desc
    raise ApplicationController::NotAuthorized.new() unless permitted_orders.include(attr)
    orders = {}
    orders[attr] = desc ? :desc : :asc
    results.orders(orders)
  end

  def apply_paging(results)
    return results if self.page_size.blank?
    results = results.offset(page_size * (page_index || 0)) if page_index.present?
    results.limit(page_size)
  end

  def default_search?
    query.blank? && sort_order.blank? && ids.blank? &&
      min_id.blank? && (page_index.blank? || page_index.to_i == 0)
  end

end
