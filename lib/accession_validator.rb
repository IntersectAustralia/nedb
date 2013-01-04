class AccessionValidator < ActiveModel::Validator

  def validate(record)
  	unless record.nil?
  	  if record.id < 1
  	  	record.errors[:base] << 'Accession number needs to be greater than 0'
  	  elsif not Specimen.where(:id => record.id).empty?
  	  	record.errors[:base] << "Supplied accession number #{record.id} already in use"
  	  elsif Specimen.last.nil? or record.id >= Specimen.last.id
  	  	record.errors[:base] << "Supplied accession number #{record.id} is out of range"
  	  end
  	end
  end

end