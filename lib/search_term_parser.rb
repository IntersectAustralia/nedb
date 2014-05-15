class SearchTermParser

  def initialize(raw_search_term)
    @raw_search_term = raw_search_term.nil? ? nil : raw_search_term.strip
  end

  def is_blank?
    @raw_search_term.blank?
  end

  def accession_number_search?
    !accession_number.nil?
  end

  def accession_number
    if @raw_search_term =~ /^#{Setting.instance.specimen_prefix}[0-9]+\.[0-9a-zA-Z]+$/
      # its in the format NE[accession_no].[item_number or rep code]
      dot_location = @raw_search_term.index(".")
      return @raw_search_term[2..(dot_location - 1)]
    elsif @raw_search_term =~ /^#{Setting.instance.specimen_prefix}[0-9]+$/
      # its in the format NE[accession_no]
      return @raw_search_term[2, @raw_search_term.length]
    elsif @raw_search_term =~ /^[0-9]+$/
      # its just the number
      return @raw_search_term
    else
      return nil
    end
  end

  def text_search
    @raw_search_term
  end

end
