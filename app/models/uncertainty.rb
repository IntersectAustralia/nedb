class Uncertainty < ActiveRecord::Base
  belongs_to :determination
  belongs_to :uncertainty_type
end
