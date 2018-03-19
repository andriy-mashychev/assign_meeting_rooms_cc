module ZenMate
  class Meeting
    include Comparable

    DurationError = Class.new RangeError

    def initialize subject:, duration_minutes:
      @subject = subject
      @duration = duration_minutes.to_i

      if @duration < 1
        raise DurationError, 'Minutes should be a positive integer.', caller
      end
    end

    attr_reader :duration, :subject

    def <=> other
      return unless other.is_a? self.class
      duration <=> other.duration
    end

    def to_s
      "#{subject} #{duration}min"
    end
  end
end