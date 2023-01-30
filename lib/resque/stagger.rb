require "resque/stagger/version"

module Resque
  module Stagger
    class Staggered
      def initialize(**options)
        @options = options
      end

      def enqueue(klass, *args)
        ::Resque.enqueue_at(current_enqueue_at, klass, *args)
      end

      private

      def current_enqueue_at
        @__enqueued_last_second = @__enqueued_last_second.to_i + 1
        return starting_from if per_second.to_i.zero?
        return @__last_enqueued_at = starting_from if @__last_enqueued_at.blank?
        return @__last_enqueued_at if @__enqueued_last_second <= per_second

        @__enqueued_last_second = 0
        @__last_enqueued_at += 1.second
      end

      def starting_from
        @starting_from ||= @options[:start_from] || Time.current
      end

      def per_second
        @options[:per_second] || nil
      end
    end
  end
end
