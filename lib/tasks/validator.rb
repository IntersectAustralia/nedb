require 'set'

def do_validation
  #validate_model BotanicalDivision
  #validate_model Confirmation
  #validate_model Country
  #validate_model Determination
  #validate_model Form
  #validate_model Herbarium
  #validate_model Item
  #validate_model ItemType
  #validate_model Permission
  #validate_model Person
  #validate_model Profile
  #validate_model Species
  #validate_model Specimen
  #validate_model SpecimenImage
  #validate_model State
  #validate_model Subspecies
  validate_model Uncertainty
  #validate_model UncertaintyType
  #validate_model User
  #validate_model Variety
end

def validate_model(model)
  count_rows = model.count
  puts "Validating #{model}. #{count_rows} rows"

  errors = {}

  model.all.each do |model_row|
    unless model_row.valid?
      new_failures = remove_existing_failures(errors.keys, flatten_errors(model_row.errors))
      new_failures.each do |failure|
        errors[failure] = "#{model}[#{model_row.id}]"
      end
    end
  end

  report_errors errors
end

def report_errors(errors)
  if (errors.empty?)
    puts "No validation errors found"
  else
    errors.each do |error, first_record|
      puts "#{error} first found in record #{first_record}"
    end
  end
end

def remove_existing_failures(current_failures, new_failures)
  new_failures.delete_if { |error| current_failures.member?(error) }
end

# Converts an error hash of the form of 
#   {:attribure => ["validation failure1"], :attr => ["failed"]}
# To a set
#   ("attribute validation failure","attr failed")
def flatten_errors(error_hash)
  error_array = Set.new
  error_hash.each do |key, validation_problem|
    error_array << "#{key}: #{validation_problem}"
  end
  error_array
end


