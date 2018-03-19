require 'test_helper'

class MeetingTest < Minitest::Test
  def an_ordinary_meeting_15
    @_meeting_15 ||= ZenMate::Meeting.new(subject: 'Telling jokes', duration_minutes: 15)
  end

  def an_ordinary_meeting_20
    @_meeting_20 ||= ZenMate::Meeting.new(subject: 'Telling jokes', duration_minutes: 20)
  end

  def test_that_it_is_created_with_correct_attributes
    assert_equal an_ordinary_meeting_15.duration, 15
    assert_equal an_ordinary_meeting_15.subject, 'Telling jokes'
  end

  def test_that_it_can_be_converted_to_a_string
    assert_equal an_ordinary_meeting_15.to_s, 'Telling jokes 15min'
  end

  def test_the_duration_to_be_always_interpreted_as_integer
    float_meeting = ZenMate::Meeting.new(subject: 'Laughing hard', duration_minutes: 15.7)
    assert_equal float_meeting.duration, 15
  end

  def test_that_it_raises_an_error_when_the_duration_equals_zero
    assert_raises(ZenMate::Meeting::DurationError) do
      ZenMate::Meeting.new(subject: 'Laughing hard', duration_minutes: 0)
    end
  end

  def test_that_it_raises_an_error_when_the_duration_is_negative
    assert_raises(ZenMate::Meeting::DurationError) do
      ZenMate::Meeting.new(subject: 'Laughing hard', duration_minutes: -1)
    end
  end

  def test_whether_class_instances_are_comparable
    assert_includes ZenMate::Meeting.included_modules, Comparable

    assert_nil an_ordinary_meeting_15 <=> 50
    assert_equal an_ordinary_meeting_15 <=> an_ordinary_meeting_15, 0
    assert_equal an_ordinary_meeting_15 <=> an_ordinary_meeting_20, -1
    assert_equal an_ordinary_meeting_20 <=> an_ordinary_meeting_15, 1
  end
end