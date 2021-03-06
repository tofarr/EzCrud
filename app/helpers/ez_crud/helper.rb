require "ez_crud/attrs"
require "ez_crud/not_authorized"
require 'data_uri'
require 'mime-types'

module EzCrud::Helper

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
    base.send :helper_method, :ez_crud_index
    base.send :helper_method, :ez_crud_show
    base.send :helper_method, :ez_crud_form

    base.send :helper_method, :viewable?
    base.send :helper_method, :editable?
    base.send :helper_method, :destroyable?
    base.send :helper_method, :creatable?
    base.send :helper_method, :bulk_edits?
  end

  module InstanceMethods

    # GET /<model_type>
    # GET /<model_type>.json
    def index
      @models = current_models
      respond_to do |format|
        format.html do #use ez_crud if the template is missing use the default ez crud template
          render "ez_crud/index.html.erb" unless template_exists? "#{model_class.name.underscore.pluralize}/index.html.erb"
        end
        format.json do
          render(json: {search: @search, models: @models}) unless template_exists? "#{model_class.name.underscore.pluralize}/index.json.jbuilder"
        end
        format.csv do
          response.headers['Content-Disposition'] = "attachment; filename=\"#{model_class.name}-#{Date.today}.csv\""
          render "ez_crud/index.csv.erb" unless template_exists? "#{model_class.name.underscore.pluralize}/index.csv.erb"
        end
      end
    end

    # GET /<model_type>/count
    # GET /<model_type>/count.json
    def count
      @count = current_search.count(model_class.all)
      render json: {count: @count}
    end

    # GET /<model_type>/1
    # GET /<model_type>/1.json
    def show
      @model = current_model
      raise EzCrud::NotAuthorized unless viewable?(@model)
      respond_to do |format|
        format.html do #use ez_crud if the template is missing use the default ez crud template
          render "ez_crud/show.html.erb" unless template_exists? "#{model_class.name.underscore.pluralize}/show.html.erb"
        end
        format.json do
          render(json: {model: @model}) unless template_exists? "#{model_class.name.underscore.pluralize}/show.json.jbuilder"
        end
      end
    end

    # GET /${model_type}/new
    def new
      @model = model_class.new
      raise EzCrud::NotAuthorized unless creatable?(@model)
      respond_to do |format|
        format.html do #use ez_crud if the template is missing use the default ez crud template
          render "ez_crud/new.html.erb" unless template_exists? "#{model_class.name.underscore.pluralize}/new.html.erb"
        end
        format.json do
          render(json: {model: @model}) unless template_exists? "#{model_class.name.underscore.pluralize}/new.json.jbuilder"
        end
      end
    end

    # GET /${model_type}/1/edit
    def edit
      @model = current_model
      raise EzCrud::NotAuthorized unless editable?(@model)
      respond_to do |format|
        format.html do #use ez_crud if the template is missing use the default ez crud template
          render "ez_crud/edit.html.erb" unless template_exists? "#{model_class.name.underscore.pluralize}/edit.html.erb"
        end
        format.json do
          render(json: {model: @model}) unless template_exists? "#{model_class.name.underscore.pluralize}/edit.json.jbuilder"
        end
      end
    end

    # POST /<model_type>
    # POST /<model_type>.json
    def create
      @model = model_class.new(model_params)
      assign_attributes(@model)
      raise EzCrud::NotAuthorized unless creatable?(@model)
      respond_to do |format|
        if @model.save
          format.html { redirect_to @model, notice: I18n.t('ez_crud.create_successful') }
          format.json { render :show, status: :created, location: @model }
        else
          format.html {
            template = "#{model_class.name.underscore.pluralize}/new.html.erb"
            template = "ez_crud/new.html.erb" unless template_exists? template
            render template
          }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /<model_type>/1
    # PATCH/PUT /<model_type>/1.json
    def update
      @model = current_model
      raise EzCrud::NotAuthorized unless updatable?(current_model)
      assign_attributes(@model)
      respond_to do |format|
        if @model.save
          format.html { redirect_to @model, notice: I18n.t('ez_crud.update_successful') }
          format.json { render :show, status: :ok, location: @model }
        else
          format.html {
            template = "#{model_class.name.underscore.pluralize}/edit.html.erb"
            template = "ez_crud/edit.html.erb" unless template_exists? template
            render template
          }
          format.json { render json: @model.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /${model_type}/1
    # DELETE /${model_type}/1.json
    def destroy
      @model = current_model
      raise EzCrud::NotAuthorized unless destroyable?(@model)
      @model.destroy
      respond_to do |format|
        format.html { redirect_to url_for(action: :index), notice: I18n.t('ez_crud.destroy_successful') }
        format.json { head :no_content }
      end
    end

    # GET /${model_type}/edit_all
    # DELETE /${model_type}/1.json
    def bulk_edit
      raise EzCrud::NotAuthorized unless bulk_edits?
      @cjob_spec = current_job_spec
      respond_to do |format|
        format.html do #use ez_crud if the template is missing use the default ez crud template
          render "ez_crud/bulk_edit.html.erb" unless template_exists? "#{model_class.name.underscore.pluralize}/bulk_edit.html.erb"
        end
        format.json do
          render(json: {job_spec: @job_spec}) unless template_exists? "#{model_class.name.underscore.pluralize}/bulk_edit.json.jbuilder"
        end
      end
    end

    # PUT /${model_type}
    # PUT /${model_type}.json
    # PATCH /${model_type}
    # PATCH /${model_type}.json
    def bulk_update
      raise EzCrud::NotAuthorized unless bulk_edits?
      @job_spec = current_job_spec
      if @job_spec.save
        EzCrudJob.perform_later(@job_spec.id)
        respond_to do |format|
          format.html { redirect_to send("#{model_class.name.underscore}_url"), notice: I18n.t('job_submitted') }
          format.json { render :show, status: :ok, location: url_for(controller: "", action: "bulk_edit") }
        end
      else
        respond_to do |format|
          format.html { render :bulk_edit }
          format.json { render json: @job_spec.errors, status: :unprocessable_entity }
        end
      end
    end

    def model_class
      @model_class ||= self.class.model_class
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      param_names = self.class.model_param_names
      return {} if param_names.blank?
      params.require(model_class.name.underscore).permit(*param_names)
    end

    def assign_attributes(model)
      model.assign_attributes(model_params)
      self.class.json_param_names.each do |attr|
        json = JSON.parse(model.send(attr))
        model.send("#{attr}=", json)
      end
      self.class.model_attachment_names.each do |attr|
        process_upload(attr)
      end
      model
    end

    def current_model
      @model ||= model_class.find(params[:id])
    end

    def current_search
      @search ||= self.class.search_class.new(params[:search])
    end

    def current_models
      @models ||= current_search.search(model_class.all)
    end

    def current_count
      @count ||= current_search.count(model_class.all)
    end


    def current_job_spec
      action = params[:action]
      action = params[:destroy] ? :destroy : :upsert unless action
      @job_spec ||= case action.to_sym
                                    when :destroy, :delete
                                      current_bulk_destroy_spec
                                    else
                                      current_bulk_upsert_spec
                                    end
    end

    def current_bulk_destroy_spec
      spec = self.class.bulk_destroy_job_spec_class.new
      spec.model_type = model_class.name
      if params[:batch_file]
        process_file(params[:batch_file], spec, :batch_file)
      else
        spec.search = current_search
      end
      spec
    end

    def current_bulk_upsert_spec
      spec = self.class.bulk_upsert_job_spec_class.new
      spec.model_type = model_class.name
      if params[:batch_file]
        process_file(params[:batch_file], spec, :batch_file)
      else
        spec.search = current_search
        begin
          spec.params = model_params.as_json
        rescue StandardError => e
          #No action required...
        end
      end
      spec
    end

    def process_upload(attr_sym)
      if params[model_class.name.underscore]["destroy_#{attr_sym}".to_sym]
        attr = current_model.send(attr_sym)
        attr.purge if attr.attached?
        return
      end
      f = params[model_class.name.underscore][attr_sym]
      process_file(f, current_model, attr_sym) if f
    end

    def process_file(f, model, attr_sym)
      if f.class.name == 'String' && f.starts_with?('data:') # String was sent - manually convert to file
        uri = URI::Data.new(f)
        extension = MIME::Types[uri.content_type].first.extensions.first
        model.send(attr_sym).attach(io: StringIO.new(uri.data), filename: "upload.#{extension}")
      else
        model.send(attr_sym).attach(f)
      end
    end

    def creatable?(model=nil)
      true
    end

    def viewable?(model)
      true
    end

    def editable?(model)
      true
    end

    def updatable?(model)
      true
    end

    def destroyable?(model)
      true
    end

    def bulk_edits?
      true
    end

  end

  module ClassMethods

    include EzCrud::Util

    def model_class
      cache_var(:@model_class) { Object.const_get(self.name.gsub("Controller", "").singularize) }
    end

    def model_param_names
      cache_var(:@model_param_names) do
        types = EzCrud::Attrs.attr_types(self.model_class)
        EzCrud::Attrs.param_names(self.model_class).reject do |attr|
          types[attr] == ActiveStorage::Attachment
        end
      end
    end

    def model_attachment_names
      cache_var(:@model_attachment_names) do
        types = EzCrud::Attrs.attr_types(self.model_class)
        EzCrud::Attrs.param_names(self.model_class).select do |attr|
          types[attr] == ActiveStorage::Attachment
        end
      end
    end

    def json_param_names
      cache_var(:@model_attachment_names) do
        types = EzCrud::Attrs.attr_types(self.model_class)
        EzCrud::Attrs.param_names(self.model_class).select do |attr|
          types[attr] == :json
        end
      end
    end

    def search_class
      cache_var(:@search_class) do
        begin
          Object.const_get("Search::#{self.name.gsub("Controller", "").singularize}Search")
        rescue NameError => e
          EzCrud::Search
        end
      end
    end

    def bulk_destroy_job_spec_class
      cache_var(:@bulk_destroy_class) do
        begin
          Object.const_get("#{self.name.gsub("Controller", "").singularize}BulkDestroyJobSpec")
        rescue NameError => e
          EzCrud::BulkDestroyJobSpec
        end
      end
    end

    def bulk_upsert_job_spec_class
      cache_var(:@bulk_upsert_class) do
        begin
          Object.const_get("#{self.name.gsub("Controller", "").singularize}BulkUpsertJobSpec")
        rescue NameError => e
          EzCrud::BulkUpsertJobSpec
        end
      end
    end

  end

end
