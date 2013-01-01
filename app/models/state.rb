class State < ActiveRecord::Base
  belongs_to :country
  has_many :botanical_divisions
  
  validates :country, :presence => true
  validates :name, :presence => true
end
