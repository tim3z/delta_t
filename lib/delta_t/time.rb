class Time
  old_plus = instance_method :+
  old_minus = instance_method :-

  define_method :+  do |other|
    if other.class == DeltaT::TimeDiff
      other + self
    else
      old_plus.bind(self).(other)
    end
  end

  define_method :-  do |other|
    if other.class == DeltaT::TimeDiff
      (other*-1) + self
    elsif other.respond_to? :to_time
      DeltaT::TimeDiff.new self, other
    else
      old_minus.bind(self).(other)
    end
  end
end