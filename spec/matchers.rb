module Matchers

  # Ensure that the attribute is validated to be an integer
  #
  # Example:
  # it { should validate_integerality_of(:age) }
  #
  def validate_integerality_of(attr)
    ValidateIntegeralityOfMatcher.new(attr)
  end

  # Ensure that the attribute is validated to be within a range
  #
  # Example:
  # it { should validate_range_of(:age, 0, 110) }
  #
  def validate_range_of(attr,from,to)
    ValidateRangeOfMatcher.new(attr,from,to)
  end

  class ValidateIntegeralityOfMatcher < Shoulda::ActiveRecord::Matchers::ValidationMatcher

    def with_message(message)
      @expected_message = message if message
      self
    end
    
    def matches?(subject)
      super(subject)
      @expected_message ||= "must be an integer"
      disallows_value_of('1.1', @expected_message)
    end

    def description
      "only allow integer values for #{@attribute}"
    end
  end

  class ValidateRangeOfMatcher < Shoulda::ActiveRecord::Matchers::ValidationMatcher

    def initialize(attribute,from,to)
      @attribute = attribute
      @from = from
      @to = to
    end

    def matches?(subject)
      super(subject)
      disallows_value_of(@from - 1, "must be greater than or equal to #{@from}")
      allows_value_of(@from)
      allows_value_of(@from + 1) 
      allows_value_of(@to - 1)
      allows_value_of(@to)
      disallows_value_of(@to + 1, "must be less than or equal to #{@to}") 
    end

    def description
      "only allow a range of values for #{@attribute}"
    end
  end
end