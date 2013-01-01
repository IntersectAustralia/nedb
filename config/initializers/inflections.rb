# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'specimen', 'specimens'
  inflect.irregular 'herbarium', 'herbaria'
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
  inflect.uncountable %w(species)
  inflect.uncountable %w(subspecies)
end
