require 'simplecov-rcov'
class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end
SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
SimpleCov.merge_timeout(7200)
SimpleCov.start 'rails' do
  # any custom configs like groups and filters can be here at a central place
  add_filter "/vendor/"
end
