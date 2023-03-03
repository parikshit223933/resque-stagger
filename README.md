# Resque-Stagger

resque-stagger is a simple Ruby gem that allows you to stagger the enqueuing of jobs
in [Resque](https://github.com/resque/resque).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-stagger'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install resque-stagger
```

## Usage

```ruby
require 'resque/staggered'

# Set up a new staggered queue
queue = Resque::Staggered.new(
  start_from: Time.now + 60, # Start queuing jobs 60 seconds from now
  number_of_jobs: 10, # Enqueue 10 jobs per time interval
  unit_time_in_seconds: 300, # Interval of 5 minutes between each set of jobs
  queue: 'low' # Enqueue jobs in the 'low' queue
)

# Enqueue a job with arguments
queue.enqueue(MyJobClass, arg1, arg2, arg3)
```

- The code sets up a new staggered queue using Resque::Staggered and then enqueues a job with arguments using the
  enqueue method of the staggered queue.

- Based on the options passed to the Resque::Staggered constructor, the staggered queue will enqueue 10 jobs every 5
  minutes (300 seconds) starting 60 seconds from the current time, and enqueue the jobs in the "low" queue.

- So, if this code is run at 12:00 PM, the first set of 10 jobs will be enqueued at 12:01 PM (60 seconds later), the
  second set of 10 jobs will be enqueued at 12:06 PM (5 minutes later), the third set of 10 jobs will be enqueued at 12:
  11 PM (5 minutes later), and so on.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/parikshit223933/resque-stagger.

## License

The gem is available as open source under the terms of
the [MIT License](https://github.com/parikshit223933/resque-stagger/blob/master/LICENSE.txt).
