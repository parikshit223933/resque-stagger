# Resque Stagger

A Resque plugin for adding a stagger effect to enqueuing jobs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resque-stagger'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install resque-stagger

## Usage

You can use `Resque::Staggered` to enqueue jobs with a stagger effect.

```ruby
require "resque/stagger"

staggered_instance = Resque::Staggered.new(per_second: 2, start_from: Time.now + 5.seconds)
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 1.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 1.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 2.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 2.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 3.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 3.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 4.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 4.second
staggered_instance.enqueue(MyJob, "arg1", "arg2") # This will be enqueued at Time.now + 5.seconds + 5.second

```

The Staggered class takes two optional parameters: :per_second and :start_from.

> **:per_second** is the number of jobs to enqueue per second. The default value is nil, which means no limit on the number of jobs to enqueue per second.

> **:start_from** is the starting time for enqueuing jobs. The default value is Time.current.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/resque-stagger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Resque Stagger project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/resque-stagger/blob/master/CODE_OF_CONDUCT.md).

