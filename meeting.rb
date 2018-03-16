module ZenMate
  class Meeting
    include Comparable

    DurationError = Class.new RangeError

    def initialize subject:, duration_minutes:
      @subject = subject
      @duration = duration_minutes.to_i
      raise(DurationError, 'Minutes should be a positive integer.', caller) if @duration < 1
    end

    attr_reader :duration, :subject

    def <=> other
      duration <=> other.duration
    end

    def to_s
      "#{subject} #{duration}min"
    end
  end
end