class SpecimenSecondaryCollector < ActiveRecord::Base
  belongs_to :specimen
  belongs_to :collector
end
