
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
      raise ApplicationController::BadRequest.new() if (hash[:enforce_limit] != false) && (page_size > Rails.configuration.ez_crud_max_page_size)
    end
    self.ids = ids.reject{|v| v.empty? }.map{|v| v.to_i } if ids.present?
    self.page_size = page_size.present? ? page_size.to_i : Rails.configuration.ez_crud_max_page_size
    self.page_index =  page_index.present? ? page_index.to_i : 0
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

  def num_pages(results)
    (count(results).to_f / page_size).ceil
  end

  def apply_ids(results)
    results = results.where(id: ids) if ids.present?
    results
  end

  def filter_attrs(results)
    results.columns.select{|c| c.type==:string || c.type==:text }.map{|c|c.name.to_sym}
  end

  def apply_query(results)
    if query.present?
      like = "%#{query}%"
      s = StringIO.new
      attrs = filter_attrs(results)
      attrs.inject(true) do |first, attr|
        s << ' OR ' unless first
        s << attr
        s << ' LIKE ?'
        false
      end
      results = results.where(*Array.new(attrs.length, like).unshift(s.string))
    end
    results = results.where("id < ?", max_id) if max_id.present?
    results
  end

  def permitted_orders(results)
    filter_attrs(results) + [:id, :created_at, :updated_at]
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
    raise ApplicationController::NotAuthorized.new() unless permitted_orders(results).include(attr)
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
    query.blank? && sort_order.blank? && ids.blank?
  end

end
