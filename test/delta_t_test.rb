require File.dirname(__FILE__) + '/helper'

class DeltaTTest < Test::Unit::TestCase

  def assert_components expected, actual
    assert_equal expected, [actual.years, actual.months, actual.days, actual.hours, actual.minutes, actual.seconds]
  end

  # caution - depends on current time so if buggy non deterministic
  def test_simple_difference
    now = Time.now
    dif = DeltaT::TimeDiff.new(now, now - (1.days + 3.hours))
    assert_equal 0, dif.years
    assert_equal 0, dif.months
    assert_equal 1, dif.days
    assert_equal 3, dif.hours
    assert_equal 0, dif.minutes
    assert_equal 0, dif.seconds
  end

  def test_overlapping_difference
    assert_components [0,0,0,0,0,2], DeltaT::TimeDiff.new(Time.new(2000, 1, 1, 0, 1 , 1), Time.new(2000, 1, 1, 0, 0, 59))
    assert_components [0,0,2,0,0,0], DeltaT::TimeDiff.new(Time.new(2000, 2, 1), Time.new(2000, 1, 30))
  end

  def test_negative_difference
    assert_components [1, 2, 10, 0, 3, 2], DeltaT::TimeDiff.new(Time.new(2001, 6, 15, 10, 4, 1), Time.new(2000, 4, 5, 10, 0, 59))
    assert_components [-1, -2, -10, 0, -3, -2], DeltaT::TimeDiff.new(Time.new(2000, 4, 5, 10, 0, 59), Time.new(2001, 6, 15, 10, 4, 1))
  end

  def test_init
    assert_components [1,2,3,4,5,6], DeltaT::TimeDiff.new(years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6)
    assert_components [1,0,3,0,0,0], DeltaT::TimeDiff.new(years: 1, days: 3)
    assert_components [1,0,0,0,0,0], DeltaT::TimeDiff.new(years: 1)
  end

  def test_equals
    t = DeltaT::TimeDiff.new(years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6)
    assert t == t
    assert t != -t
  end

  def test_total
    assert_equal 48, DeltaT::TimeDiff.new(days: 2).total_hours
    assert_equal 62, DeltaT::TimeDiff.new(months: 2, days: 2).total_days
    dif = DeltaT::TimeDiff.new(months: 2, days: 2, hours: 5, minutes: 7, seconds: 1)
    assert_equal 62, dif.total_days
    assert_equal 5375221, dif.total_seconds
  end

  def test_normalization
    assert_components [0,1,21,0,0,0], DeltaT::TimeDiff.new(days: 51)
    assert_components [0,1,10,18,5,0], DeltaT::TimeDiff.new(minutes: 60*24*40 + 60*18 + 5)
    assert_components [0,-1,-10,-18,-5,0], DeltaT::TimeDiff.new(minutes: -(60*24*40 + 60*18 + 5))
  end

  def test_to_hash
    h = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6, n_secs: 0}
    assert_equal h, DeltaT::TimeDiff.new(h).to_hash
  end

  def test_operators
    assert_components [1,3,0,0,0,0], (DeltaT::TimeDiff.new(months: 11) + DeltaT::TimeDiff.new(months: 4))
    assert_components [0,7,0,0,0,0], (DeltaT::TimeDiff.new(months: 11) - DeltaT::TimeDiff.new(months: 4))
    assert_components [2,9,0,0,0,0], (DeltaT::TimeDiff.new(months: 11) * 3)
  end

  def test_comparison_operators
    assert DeltaT::TimeDiff.new(months: 1) < DeltaT::TimeDiff.new(days: 35)
    assert DeltaT::TimeDiff.new(days: 35) > DeltaT::TimeDiff.new(months: 1)

    assert DeltaT::TimeDiff.new(hours: 3) <= DeltaT::TimeDiff.new(minutes: 180)
    assert DeltaT::TimeDiff.new(hours: 3) <= DeltaT::TimeDiff.new(minutes: 180, seconds: 5)
    assert !(DeltaT::TimeDiff.new(hours: 3) >= DeltaT::TimeDiff.new(minutes: 180, seconds: 5))
  end

  def test_time_operators
    before = Time.new 2001, 4, 3, 12, 23, 55
    after = Time.new 2012, 12, 21, 0, 0, 0
    assert_equal after, before + DeltaT::TimeDiff.new(after, before)
    assert_equal after, DeltaT::TimeDiff.new(after, before) + before
    assert_equal before, after - DeltaT::TimeDiff.new(after, before)
    assert_equal before, -DeltaT::TimeDiff.new(after, before) + after

    assert_equal after, before + (after - before)
    assert_equal after, after - before + before
    assert_equal before, after - (after - before)
    assert_equal before, -(after - before) + after
  end
end
