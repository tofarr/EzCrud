class DoohickeysController < ApplicationController

  include EzCrud::Helper

  # Massive performance boost - include the other items up front
  def current_models
    @models ||= super.includes(:categories, :comments)
  end

end
