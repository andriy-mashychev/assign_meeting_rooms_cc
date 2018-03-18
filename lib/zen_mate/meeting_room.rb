require 'time'
require_relative 'meeting'

module ZenMate
  class MeetingRoom
    TIME_IN_THE_MORNING = Time.parse '9 AM'
    TIME_IN_THE_AFTERNOON = Time.parse '1 PM'
    
    CAPACITY_BEFORE_LUNCH = 180
    CAPACITY_AFTER_LUNCH = 240

    def initialize number:
      @number = number
      @free_minutes_before_lunch = CAPACITY_BEFORE_LUNCH
      @free_minutes_after_lunch = CAPACITY_AFTER_LUNCH
      @meetings_before_lunch = []
      @meetings_after_lunch = []
    end

    attr_reader :free_minutes_after_lunch, :free_minutes_before_lunch,
                :meetings_after_lunch, :meetings_before_lunch, :number

    def fits_in? event
      return unless event.is_a? Meeting
      fits_in_after_lunch?(event) || fits_in_before_lunch?(event)
    end

    def fits_in_after_lunch? event
      return unless event.is_a? Meeting
      free_minutes_after_lunch >= event.duration
    end

    def fits_in_before_lunch? event
      return unless event.is_a? Meeting
      free_minutes_before_lunch >= event.duration
    end

    def print_scheduled_meetings
      print_meetings_scheduled_before_lunch
      puts "#{Time.parse('12 PM').strftime "%I:%M %p"} - Lunch."
      print_meetings_scheduled_after_lunch
    end

    def print_meetings_scheduled_before_lunch
      meetings_before_lunch.inject(TIME_IN_THE_MORNING) do |current_time, meeting|
        puts "#{current_time.strftime "%I:%M %p"} - #{meeting}."
        current_time + meeting.duration * 60
      end
    end

    def print_meetings_scheduled_after_lunch
      meetings_after_lunch.inject(TIME_IN_THE_AFTERNOON) do |current_time, meeting|
        puts "#{current_time.strftime "%I:%M %p"} - #{meeting}."
        current_time + meeting.duration * 60
      end
    end

    def schedule event
      return unless event.is_a? Meeting
      if fits_in_after_lunch? event
        put_after_lunch event
      elsif fits_in_before_lunch? event
        put_before_lunch event
      else
        print_scheduling_error_for event
      end
    end
    
    def to_s
      "Room #{number}"
    end

    private

    def print_scheduling_error_for event
      STDERR.puts "[#{self}] Unable to schedule the event: #{event}."
      STDERR.puts "#{free_minutes_before_lunch} minutes left before lunch."
      STDERR.puts "#{free_minutes_after_lunch} minutes left after lunch."
    end

    def put_after_lunch event
      meetings_after_lunch << event
      @free_minutes_after_lunch -= event.duration
    end

    def put_before_lunch event
      meetings_before_lunch << event
      @free_minutes_before_lunch -= event.duration
    end
  end
end