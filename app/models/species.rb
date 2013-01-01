class Species < ActiveRecord::Base

  has_many :subspecies, :dependent => :delete_all
  has_many :varieties, :dependent => :delete_all
  has_many :forms, :dependent => :delete_all

  validates :name, :presence => true, :uniqueness => {:scope => :genus, :case_sensitive => false}
  validates :genus, :presence => true
  validates :authority, :presence => true
  validates_length_of :name, :maximum => 255
  validates_length_of :genus, :maximum => 255
  validates_length_of :division, :maximum => 255
  validates_length_of :class_name, :maximum => 255
  validates_length_of :family, :maximum => 255
  validates_length_of :order_name, :maximum => 255
  validates_length_of :sub_family, :maximum => 255
  validates_length_of :tribe, :maximum => 255
  validates_length_of :authority, :maximum => 255 
  
  scope :with_genus, lambda { |genus| where(:genus => genus.capitalize) } 
  scope :with_name, lambda { |name| where(:name => name.downcase) }

  scope :alphabetical, order("division, class_name, order_name, family, sub_family, tribe, genus, name")

  # correct the case before validating
  before_validation do
    self.division = division.capitalize if attribute_present?("division")
    self.class_name = class_name.capitalize if attribute_present?("class_name")
    self.order_name = order_name.capitalize if attribute_present?("order_name")
    self.family = family.capitalize if attribute_present?("family")
    self.sub_family = sub_family.capitalize if attribute_present?("sub_family")
    self.tribe = tribe.capitalize if attribute_present?("tribe")
    self.genus = genus.capitalize if attribute_present?("genus")
    #name we leave as-is, since occasionally they have mixed case
  end

  def self.find_by_name_and_genus(name, genus)
    with_name(name).with_genus(genus).first
  end
  
  def self.autocomplete_name_with_genus(genus, name_search_term)
    autocomplete_plant_name("name", name_search_term).with_genus(genus)
  end
  
  def self.autocomplete_plant_name(level, term)
    autocomplete_search(level, term)
  end
  
  def self.free_text_search(free_text)
    # TODO: prevent SQL injection
    text = free_text.gsub("'", "''")
    search = '%' + text.downcase + '%'
    search_fields = %w{division class_name order_name family sub_family tribe genus name authority}
    condition = "(" + search_fields.collect { |field| "lower(#{field}) like '#{search}' "}.join(" OR ")
    condition += ")"
    Species.alphabetical.where(condition)
  end

  def self.search_in_field(field, text)
    srch_text = text.gsub("'", "''")
    search = '%' + srch_text.downcase + '%'
    condition = "lower(#{field}) like '#{search}'"

    fields = %w(division class_name order_name family sub_family tribe genus name)
    index_of_our_field = fields.index(field)
    fields_to_get = fields[0..index_of_our_field]

    if field == "name"
      fields_to_get << "authority"
      sort_order = %w{genus name}
    elsif field == "genus"
      sort_order = %w{genus division}
    else
      sort_order = fields_to_get
    end

    select_stmt = fields_to_get.join(", ")

    Species.select("DISTINCT #{select_stmt}").where(condition).order(sort_order)
  end
  
  private  
  def self.autocomplete_search(field, search_term)
    select("DISTINCT #{field}").where(["LOWER(#{field}) LIKE ?", "#{search_term.downcase}%"]).order(field).limit(200)
  end
  
end
