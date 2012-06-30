class TimeDiff
  UNITS = [:seconds, :minutes, :hours, :days, :months, :years]

  def initialize *args
    if args.size == 1 && args[0].class == Hash
      @diff = [0,0,0,0,0,0]
      add_array [args[0][:seconds], args[0][:minutes], args[0][:hours], args[0][:days], args[0][:months], args[0][:years]]
    elsif args.size == 2 && args[0].respond_to?(:to_time) && args[1].respond_to?(:to_time)
      apply_time_diff args[0].to_time, args[1].to_time
    else
      raise ArgumentError, "Arguments neither to times nor a hash", caller
    end
  end

  UNITS.each_index do |index|
    define_method UNITS[index] do
      @diff[index]
    end
  end

  UNITS.each_index do |index|
    define_method ("total_" + UNITS[index].to_s).to_sym do
      sum = 0
      i = index
      while i < UNITS.length
        sum += @diff[i].send UNITS[i]
        i += 1
      end
      sum / 1.send(UNITS[index])
    end
  end

  def == other
    eql = true
    UNITS.each do |unit|
      eql &= send(unit) == other.send(unit)
    end
    eql
  end

  def + other
    if other.class == TimeDiff
      TimeDiff.new(other.to_hash).add_array @diff
    elsif other.respond_to? :to_time
      other.to_time.advance self.to_hash
    else
      raise ArgumentError, "Addition only defined for TimeDiff and time like classes", caller
    end
  end

  def - other
    if other.class == TimeDiff
      self + (-other)
    else
      raise ArgumentError, "Only subtraction of TimeDiffs possible", caller
    end
  end

  def * scalar
    unless scalar.integer?
      raise ArgumentError, "Only integer calculations possible", caller
    end
    h = to_hash
    h.each { |k, v| h[k] = v * scalar }
    result = TimeDiff.new h
    result.normalize!
  end

  def -@
    self * -1
  end

  def to_hash
    h = {}
    UNITS.each do |unit|
      h[unit] = send(unit)
    end
    h
  end

  protected

  def apply_time_diff ending, start
    @diff = [ending.sec - start.sec, ending.min - start.min, ending.hour - start.hour, ending.day - start.day, ending.month - start.month, ending.year - start.year]
    normalize! start
  end

  def add_array array
    array.each_index do |i|
      @diff[i] += array[i] unless array[i].nil?
    end
    normalize!
  end

  def normalize! base_date=nil, recalculate=false
    if base_date && recalculate
      ending = base_date + self
      apply_time_diff ending, base_date
    else
      switched = false
      if total_seconds < 0
        @diff.collect! { |t| t * -1 }
        switched = true
      end

      @diff.each_index do |index|
        (index+1...UNITS.length).to_a.each do |unit|
          base = TimeDiff.get_ratio UNITS[unit], UNITS[index], base_date
          @diff[unit] += @diff[index] / base
          @diff[index] %= base
        end
      end

      @diff.collect! { |t| t * -1 } if switched
      self
    end
  end

  def self.get_ratio numerator_unit, denominator_unit, base_date=nil
    if base_date && numerator_unit == :months && denominator_unit == :days
      Time.days_in_month base_date.month, base_date.year
    else
      (1.send(numerator_unit) / 1.send(denominator_unit)).round
    end
  end

end
