module EzCrud::Helper

  # GET /<model_type>
  # GET /<model_type>.json
  def index
    current_models
  end

  # GET /<model_type>/count
  # GET /<model_type>/count.json
  def count
    @count = current_search.count
  end

  # GET /<model_type>/1
  # GET /<model_type>/1.json
  def show
    current_model
  end

  # GET /access_tokens/new
  def new
    @model = self.class.model_class.new
  end

  # GET /access_tokens/1/edit
  def edit
    current_model
  end

  # POST /<model_type>
  # POST /<model_type>.json
  def create
    @model = self.class.model_class.new(model_params)
    assign_attributes(@model)
    respond_to do |format|
      if @model.save
        format.html { redirect_to @model, notice: I18n.t('create_successful') }
        format.json { render :show, status: :created, location: @model }
      else
        format.html { render :new }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /<model_type>/1
  # PATCH/PUT /<model_type>/1.json
  def update
    assign_attributes(@model)
    respond_to do |format|
      if @model.update(access_token_params)
        format.html { redirect_to @model, notice: I18n.t('update_successful') }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /${model_type}/1
  # DELETE /${model_type}/1.json
  def destroy
    @model.destroy
    respond_to do |format|
      format.html { redirect_to access_tokens_url, notice: 'Access token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /${model_type}/edit_all
  # DELETE /${model_type}/1.json
  def edit_all
    current_search
  end

  # PATCH /${model_type}
  # PATCH /${model_type}.json
  def update_all
    @update_all_spec = create_update_all_spec
    if @update_all_spec.save
      EzCrudJob.perform_later(@destroy_all_spec.id)
      respond_to do |format|
        format.html { redirect_to users_url, notice: I18n.t('job_submitted') }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :edit_all }
        format.json { render json: @user_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /${model_type}
  # DELETE /${model_type}.json
  def destroy_all
    @destroy_all_spec = create_destroy_all_spec
    if @destroy_all_spec.save
      EzCrudJob.perform_later(@destroy_all_spec.id)
      respond_to do |format|
        format.html { redirect_to :access_tokens, notice: I18n.t('job_submitted') }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :access_tokens }
        format.json { render json: @access_token_job.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def self.model_class
      @model_class ||= Object.const_get(self.name.gsub("Controller", "").singularize)
    end

    def self.model_param_names
      @mode_param_names ||= self.class.model_class.column_names.map(&:to_sym) - [:id, :created_at, :updated_at]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      param_names = model_param_names
      params.require(:model).permit(*param_names)
    end

    def assign_attributes(model)
      model.assign_attributes(model_params)
    end

    def current_model
      @model ||= self.class.model_class.find(params[:id])
    end

    def self.search_class
      @search_class ||= begin
                           Object.const_get("Search::#{self.name.gsub("Controller", "").singularize}Search")
                         rescue NameError => e
                           EzCrud::Search
                         end
      @search_class
    end

    def current_search
      @search ||= self.class.search_class.new(params[:search])
    end

    def current_models
      @models ||= current_search.search(self.class.model_class.all)
    end

    def current_count
      @count ||= current_search.count(self.class.model_class.all)
    end

    def create_destroy_all_spec
      destroy_all_spec = destroy_all_class.new
      destroy_all_spec.model_type = model_class.name
      if params[:batch_file]
        process_file(params[:batch_file], destroy_all_spec, :batch_file)
      else
        destroy_all_spec.search = current_search
      end
      destroy_all_spec
    end

    def self.destroy_all_class
      @destroy_all_class ||= begin
                           Object.const_get("#{self.name.gsub("Controller", "").singularize}DestroyAllJob")
                         rescue NameError => e
                           EzCrud::DestroyAllJobSpec
                         end
      @destroy_all_class
    end

    def create_update_all_spec
      update_all_spec = update_all_class.new
      update_all_spec.model_type = model_class.name
      if params[:batch_file]
        process_file(params[:batch_file], update_all_spec, :batch_file)
      else
        update_all_spec.search = current_search
        update_all_spec.updates = model_params
      end
      update_all_spec
    end

    def self.upsert_all_class
      @upsert_all_class ||= begin
                           Object.const_get("#{self.name.gsub("Controller", "").singularize}UpsertAllJob")
                         rescue NameError => e
                           EzCrud::UpdateAllJobSpec
                         end
      @upsert_all_class
    end

    def process_upload(attr_sym)
      if params[:model]["destroy_#{attr_sym}".to_sym]
        attr = current_model.send(attr_sym)
        attr.purge if attr.attached?
        return
      end
      f = params[:model][attr_sym]
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

end
