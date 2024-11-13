require 'resque/server'
require 'erb'
require 'json'

module Resque
  module Plugins
    module Stagger
      module Server
        # Define the path to your gem's views
        VIEW_PATH = File.join(File.dirname(__FILE__), 'server', 'views')

        class << self
          def registered(app)
            # Add "Staggered Jobs" tab to Resque's navigation
            app.tabs << "Staggering"

            app.get "/staggering" do
              @error = params[:error]
              @success = params[:success]
              erb File.read(File.join(__dir__, 'server', 'views', 'stagger.erb'))
            end

            app.post "/staggering/restagger" do
              job_class = params[:job_class].to_s.strip

              # Validate job class name
              if job_class.blank?
                redirect "/resque/staggering?error=Job+class+name+cannot+be+blank."
              end

              begin
                klass = job_class.constantize
              rescue NameError
                redirect "/resque/staggering?error=Job+class+#{job_class}+not+found."
              end

              # Remove all jobs of the specified class from all queues
              Resque.queues.each do |queue|
                queue_key = "queue:#{queue}"
                jobs = Resque.redis.lrange(queue_key, 0, -1)
                jobs.each do |job|
                  job_data = JSON.parse(job)
                  if job_data['class'] == job_class
                    Resque.redis.lrem(queue_key, 0, job)
                  end
                end
              end

              # Fetch configuration options from the form
              begin
                start_from = params[:start_from].present? ? Time.parse(params[:start_from]) : Time.current
              rescue ArgumentError
                redirect "/resque/staggering?error=Invalid+Start+From+time+format."
              end

              number_of_jobs = params[:number_of_jobs].to_i
              unit_time_in_seconds = params[:unit_time_in_seconds].to_i
              queue_name = params[:queue].present? ? params[:queue].strip : nil

              # Validate numerical inputs
              if number_of_jobs <= 0 || unit_time_in_seconds <= 0
                redirect "/resque/staggering?error=Number+of+Jobs+and+Interval+Time+must+be+greater+than+zero."
              end

              # Initialize Staggered object with provided options
              staggered = Resque::Plugins::Stagger::Staggered.new(
                start_from: start_from,
                number_of_jobs: number_of_jobs,
                unit_time_in_seconds: unit_time_in_seconds,
                queue: queue_name
              )

              # Fetch all job arguments for the specified class
              all_jobs = Resque.queues.flat_map do |queue|
                jobs = Resque.redis.lrange("queue:#{queue}", 0, -1)
                jobs.map do |job|
                  job_data = JSON.parse(job)
                  job_data if job_data['class'] == job_class
                end.compact
              end

              # Enqueue jobs using staggered configuration
              all_jobs.each do |job|
                staggered.enqueue(klass, *job['args'])
              end

              redirect "/resque/staggering?success=All+jobs+for+#{job_class}+have+been+restaggered+successfully."
            end
          end
        end
      end
    end
  end
end

# Register the ServerExtension with Resque::Server
Resque::Server.register Resque::Plugins::Stagger::Server
