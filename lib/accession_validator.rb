class AccessionValidator < ActiveModel::Validator

  def validate(record)
    # using where instead of find so it doesn't raise ActiveRecord::RecordNotFound
    existing_record = Specimen.where(:id => record.id).first
  	unless record.nil? or record.eql? existing_record
  	  if record.id < 1
  	  	record.errors[:base] << 'Accession number needs to be greater than 0'
  	  elsif not existing_record.nil?
  	  	record.errors[:base] << "Supplied accession number #{record.id} already in use"
  	  elsif Specimen.last.nil? or record.id >= Specimen.last.id
  	  	record.errors[:base] << "Supplied accession number #{record.id} is out of range"
  	  end
  	end
  end

end