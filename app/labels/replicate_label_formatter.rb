class ReplicateLabelFormatter < LabelFormatter

  def initialize(specimen, replicate)
    @specimen = specimen
    raise "Can only be used on replicates" unless replicate.is_a?(Herbarium)
    @replicate = replicate
  end

  def show_ex?
    !@replicate.student_herbarium?
  end

  # the text that gets encoded into the barcode
  def barcode_value
    "#{Setting.instance.specimen_prefix}#{@specimen.id}.#{@replicate.code.upcase}"
  end

  # the text that appears below the barcode
  def barcode_label
    "Do not cite: #{Setting.instance.specimen_prefix}#{@specimen.id}.#{@replicate.code}"
  end

  # replicate labels never have numbering
  def sheet(current_label_number)
    ""
  end


end