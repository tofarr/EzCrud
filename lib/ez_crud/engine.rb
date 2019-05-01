module EzCrud
  class Engine < ::Rails::Engine
    isolate_namespace EzCrud

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer :defaults do |app|
      config.ez_crud_max_page_size = 20
      config.ez_crud_show_except = [:id]
      config.ez_crud_summarize_except = [:id,:created_at]
      config.ez_crud_summarize_except_types = [:text]
      config.ez_crud_summarize_max_attrs = 5
      config.ez_crud_params_except = [:created_at,:updated_at]
    end

  end
end
