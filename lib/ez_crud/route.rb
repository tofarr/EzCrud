module EzCrud

  module Route

    def self.resource(target, *types)
      types.each do|type|
        target.resources type do
          target.get :count, on: :collection
          target.get :bulk_edit, on: :collection
        end
        target.put type, to: "#{type}#bulk_update"
        target.patch type, to: "#{type}#bulk_update"
      end
    end
  end
end
