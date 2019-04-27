class EzCrud::ProcessorJob < ApplicationJob
  queue_as :default

  def perform(job_spec_id)
    job_spec = EzCrud::JobSpec.find_by_id(job_spec_id))
    return unless job_spec
    begin
      Rails.logger.info "#{job_spec.title} starting..."
      errors = []
      job_spec.run
      job_spec.update_attributes(status: 'success')
    rescue StanardError => e
      job_spec.update_attributes(status: 'error', error: e.message)
    end
  end
end
