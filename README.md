# DeltaT

DeltaT provides an interface to represent time differences and make duration calculations nice and easy.

## Installation

Add this line to your application's Gemfile:

    gem 'delta_t'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install delta_t

## Usage

DeltaT hooks into the Time class and overrides the - operator.

    diff = (Time.now - 2.days.ago)
    diff.class # => TimeDiff

The TimeDiff class provides accessors for Years, Months, Days, Hours, Minutes and Seconds

    diff.days # => 2

The differences will always be normalized - you will never get something like 48 hours.
For the total amount of something

    diff.total_hours # => 48

Furthermore either all time amounts will be positive or negative

    diff = Time.new(2012, 2) - Time.new(2011, 11)
    diff.years # => 0
    diff.months # => 3

    diff = Time.new(2011, 11) - Time.new(2012, 2)
    diff.years # => 0
    diff.months # => -3

You can create TimeDiffs with the differences of two times or with a hash

    diff = TimeDiff.new(hours: 1, seconds: 5)
    diff.seconds # => 5
    diff.total_seconds # => 3605

and you can a hash back out of the TimeDiff

    diff.to_hash # => {years: 0, months: 0, days: 0, hours: 1, minutes: 0, seconds: 5}

You can do calculations with TimeDiffs

    diff = TimeDiff.new(days: 2) + TimeDiff.new(months: 3)
    diff.days # => 2
    diff.months # => 3

    diff - TimeDiff.new(days: 2).days # => 0

    diff * -1 == -diff # => true

When calculating a TimeDiff from two Time the day - month foobar will be handled correctly

    (Time.new(2012,4,2) - Time.new(2012,3,31)).days # => 2

but if you do any further calculations since the concrete month is unknown a month will always have 30 days.

You can apply TimeDiffs to Time objects

    Time.new(2012, 4, 5) + TimeDiff.new(days: 30) == Time.new(2012, 4, 5) + 30.days # => true

Concluding: the following equation should always be true

    (sometime - othertime) + othertime == sometime # => true


The TimeDiff class is in the DeltaT Module so normally you would have to use DeltaT::TimeDiff
For further examples have a look into the tests


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
