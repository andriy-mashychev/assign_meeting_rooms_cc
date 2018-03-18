require_relative 'meeting_room'

module ZenMate
  class MeetingRoomsAssignment
    NUMBER_OF_MEETING_ROOMS = 2

    def self.call *args
      new(*args).call
    end

    def initialize input_file_name: ARGV[0]
      @input_file = input_file_name.freeze
      @planned_meetings = []
      @rejected_meetings = []
    end

    def call
      fetch_planned_metings_and_their_durations
      fit_meetings_within_time_constraints
      print_the_timetable
      print_meetings_that_did_not_fit_in
    end

    def fetch_planned_metings_and_their_durations
      while_reading_each_line_of_the_input_file do |event|
        description = /^(?<subj>.+)\s+(?<time>\d+)min\s*$/.match event
        unless description.nil?
          meeting = Meeting.new(subject: description[:subj], duration_minutes: description[:time])
          suitable_position = planned_meetings.bsearch_index { |pm| pm > meeting } || -1
          planned_meetings.insert suitable_position, meeting
        end
      end
    end

    def fit_meetings_within_time_constraints
      until planned_meetings.empty?
        room_index = available_rooms.find_index { |room| room.fits_in? planned_meetings.last }
        if room_index.nil?
          rejected_meetings << planned_meetings.pop
        else
          available_rooms[room_index].schedule planned_meetings.pop
        end
      end
    end

    def print_meetings_that_did_not_fit_in
      puts
      if rejected_meetings.empty?
        puts 'All events have been scheduled.'
      else
        puts 'Following events could not be scheduled:'
        puts rejected_meetings.join "\n"
      end
    end

    def print_the_timetable
      available_rooms.each { |room| puts "=====> #{room}:"; room.print_scheduled_meetings }
    end

    private

    attr_reader :input_file, :planned_meetings, :rejected_meetings

    def available_rooms
      @available_rooms ||= Enumerator.new do |item|
        1.upto(NUMBER_OF_MEETING_ROOMS) { |index| item << MeetingRoom.new(number: index) }
      end.to_a
    end

    def while_reading_each_line_of_the_input_file
      File.open(input_file, 'rb') { |file_handle| file_handle.each_line { |line| yield line } }
    end
  end
end