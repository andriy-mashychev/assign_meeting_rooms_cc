require 'test_helper'

class ZenMateTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ZenMate::VERSION
  end
end