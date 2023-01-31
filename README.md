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

Bug reports and pull requests are welcome on GitHub at https://github.com/parikshit223933/resque-stagger. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.
