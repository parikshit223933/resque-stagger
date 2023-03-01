require "resque/stagger/version"

# The Resque module contains the Stagger module.
module Resque
  module Stagger
    # The Staggered class is used to enqueue jobs with a stagger effect.
    class Staggered
      # Initializes the Staggered class with given options.
      #
      # @param options [Hash] the options for the stagger effect.
      # @option options [Time] :start_from starting time for enqueuing jobs.
      # @option options [Integer] :per_second number of jobs to enqueue per second.
      # @option options [String] :queue name of the queue to enqueue jobs in.
      #
      # @return [void]
      def initialize(**options)
        @options = options
      end

      # Enqueues the given job with a stagger effect.
      #
      # @param klass [Class] the job class to be enqueued.
      # @param args [Array] the arguments for the job.
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

      # Calculates the time at which the job should be enqueued.
      #
      # @return [Time, ActiveSupport::Duration] the enqueue time for the job.
      def current_enqueue_at
        return starting_from if per_second.to_i.zero?
        return @last_enqueued_at = starting_from if @last_enqueued_at.nil?

        @enqueued_last_second = @enqueued_last_second.to_i + 1
        return @last_enqueued_at if @enqueued_last_second < per_second.to_i

        @enqueued_last_second = 0
        @last_enqueued_at += 1.second
      end

      # Gets the starting time for enqueuing jobs.
      #
      # @return [Time] the starting time for enqueuing jobs.
      def starting_from
        @starting_from ||= @options[:start_from] || Time.current
      end

      # Gets the number of jobs to enqueue per second.
      #
      # @return [Integer, nil] the number of jobs to enqueue per second.
      def per_second
        @options[:per_second] || nil
      end

      # Returns the name of the queue to enqueue jobs in.
      #
      # @return [String, nil] the name of the queue, or nil if not specified.
      def queue
        @options[:queue] || nil
      end
    end
  end
end

Resque.prepend(Resque::Stagger)
