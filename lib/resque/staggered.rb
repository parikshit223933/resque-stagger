require "resque/staggered/version"

module Resque
  class Staggered
    # Initializes a new Staggered object.
    #
    # @param options [Hash] The options to create the Staggered object with.
    # @option options [Time] :start_from The time to start enqueueing jobs from (defaults to Time.current).
    # @option options [Integer] :number_of_jobs The number of jobs to enqueue per unit time.
    # @option options [Integer] :unit_time_in_seconds The time interval between each set of jobs.
    # @option options [String] :queue The name of the queue to enqueue the jobs in (optional).
    #
    # @return [Staggered] A new instance of the Staggered class.
    def initialize(**options)
      @options = options
    end

    # Enqueues a job with the given arguments at a staggered time.
    #
    # @param klass [Object] The job class to enqueue.
    # @param args [Array] The arguments to pass to the job.
    #
    # @return [void]
    def enqueue(klass, *args)
      if queue.present?
        ::Resque.enqueue_at_with_queue(queue, current_enqueue_at, klass, *args)
      else
        ::Resque.enqueue_at(current_enqueue_at, klass, *args)
      end
    end

    private

    # Calculates the staggered time for the next job and returns it.
    #
    # @return [Time] The staggered time for the next job.
    def current_enqueue_at
      if number_of_jobs > @enqueues_in_last_unit_time.to_i
        @enqueues_in_last_unit_time = @enqueues_in_last_unit_time.to_i + 1
        if @unit_time_timestamp.nil?
          return @unit_time_timestamp = starting_from
        else
          return @unit_time_timestamp
        end
      else
        @enqueues_in_last_unit_time = 0
        @unit_time_timestamp = @unit_time_timestamp + unit_time_in_seconds.second
        current_enqueue_at
      end
    end

    # Returns the time to start from.
    #
    # @return [Time] The time to start from.
    def starting_from
      @starting_from ||= @options[:start_from] || Time.current
    end

    # Returns the number of jobs to enqueue.
    #
    # @return [Integer] The number of jobs to enqueue.
    def number_of_jobs
      @options[:number_of_jobs] || nil
    end

    # Returns the time interval between each set of jobs.
    #
    # @return [Integer] The time interval between each set of jobs.
    def unit_time_in_seconds
      @options[:unit_time_in_seconds] || nil
    end

    # Returns the name of the queue to enqueue the jobs in.
    #
    # @return [String] The name of the queue to enqueue the jobs in.
    def queue
      @options[:queue] || nil
    end
  end
end
Resque.prepend(Resque::Staggered)
