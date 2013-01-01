class Herbarium < ActiveRecord::Base
  STUDENT_HERBARIUM_CODE = "Stud."
  validates :code, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :name, :presence => true
  # since we use herbarium codes in barcodes, we only allow the characters that can be encoded (see http://rdoc.info/github/toretore/barby/Barby/Code39)
  # although lowercase characters can't be encoded, we allow them and then upcase when generating barcodes (see specimen_pdf_formatter.rb)
  validates_format_of :code, :with => /\A[A-Za-z0-9%-\/\$\+\.\s]*\z/, :message => 'Herbarium code can ony contain letters, numbers, spaces and characters . % - / $ +'
  validates_length_of :code, {:maximum => 15}

  before_validation :trim_whitespace
    
  default_scope order(:code)
  
  scope :ordered_by_code, order('code')
  
  def display_name
    "#{code} - #{name}"
  end

  def self.autocomplete_herbarium_name(term)
    autocomplete_search(term)
  end

  def self.free_text_search(free_text)
    # TODO: prevent SQL injection
    text = free_text.gsub("'", "''")
    search = '%' + text.downcase + '%'
    search_fields = %w{code name}
    condition = "(" + search_fields.collect { |field| "lower(#{field}) like '#{search}' "}.join(" OR ")
    condition += ")"
    Herbarium.ordered_by_code.where(condition)
  end

  # the student herbarium has special behaviour
  def student_herbarium?
    self.code == STUDENT_HERBARIUM_CODE
  end

  private
  
  def trim_whitespace
    self.code = self.code.strip if self.code
  end

  def self.autocomplete_search(search_term)
    Herbarium.where(["LOWER(code) LIKE ? OR LOWER(name) LIKE ?", "#{search_term.downcase}%", "#{search_term.downcase}%"]).limit(200)
  end

end
