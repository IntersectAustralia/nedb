class ItemLabelFormatter < LabelFormatter

  def initialize(specimen, item)
    @specimen = specimen
    raise "Can only be used on item" unless item.is_a?(Item)
    @item = item
  end

  def show_ex?
    false
  end

  # the text that gets encoded into the barcode
  def barcode_value
    "#{Setting.instance.specimen_prefix}#{@specimen.id}.#{@item.id}"
  end

  # the text that appears below the barcode
  def barcode_label
    "Do not cite: #{@item.id} #{@item.item_type.name}"
  end

  def sheet(current_label_number)
    total = total_number_of_numbered_sheets
    if current_label_number <= total and total > 1
      "<b>Sheet #{current_label_number} of #{total}</b>"
    else
        ""
    end
  end


end