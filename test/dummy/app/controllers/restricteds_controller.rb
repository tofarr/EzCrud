class RestrictedsController < ApplicationController

  include EzCrud::Helper

  #A bunch of random constraints...
  def creatable?(model=nil)
    #Swap this every minute (LOL!)
    DateTime.now.minute % 2 == 0
  end

  def viewable?(model)
    DateTime.now.minute % 2 == 0
  end

  def editable?(model)
    DateTime.now.minute % 2 == 0
  end

  def updatable?(model)
    DateTime.now.minute % 2 == 0
  end

  def destroyable?(model)
    DateTime.now.minute % 2 == 0
  end

  def bulk_edits?
    DateTime.now.minute % 2 == 0
  end

end
