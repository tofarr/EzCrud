module EzCrud
  class JobSpec < ApplicationRecord

    has_one_attached :batch_file

    validates :validate_batch_file_is_json_or_csv

    def title
      "#{self.class.name}:#{id}"
    end

    def model_class
      @model_class ||= Object.const_get(model_type)
    end

    def search
      @search ||= YAML::load(read_attribute(:search))
    end

    def search=(search)
      @search = search
      write_attribute(:search, YAML::dump(search))
    end

    def updates
      @updates ||= YAML::load(read_attribute(:updates))
    end

    def updates=(updates)
      @updates = updates
      write_attribute(:updates, YAML::dump(updates))
    end

    def run()
      if batch_file&.content_type == 'application/json'
        run_json
      elsif batch_file&.content_type == 'text/csv'
        run_csv
      else
        run_search
      end
    end

    def run_csv
      count = 0
      errors = []
      begin
        CSV.parse(batch_file.download, :headers => true, :header_converters => :symbol).each do |row|
          count = count + process_hash(row.to_hash, errors)
        end
      rescue StandardError => error
        errors << error
      end
      count, errors
    end

    def run_json
      count = 0
      errors = []
      begin
        JSON.parse(batch_file.download, :symbolize_names => true).each do |hash|
          count = count + process_hash(hash, errors)
        end
      rescue StandardError => error
        errors << error
      end
      count, errors
    end

    def run_search
      count = 0
      errors = []
      search.search do |model|
        count = count + process_model(updates, errors)
      end
      count, errors
    end

    def process_hash(hash, errors)
      model = model_class.find_by_id(hash[:id])
      process_model(model, hash, errors) if model
    end

    def validate_batch_file_is_json_or_csv
      if batch_file.attachment
        errors.add(:tags, I18n.t('unknown_content_type')) unless batch_file.content_type == 'application/json' || batch_file.content_type == 'text/csv'
    end
  end
end
