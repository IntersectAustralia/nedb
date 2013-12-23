class SpecimenPdfCreator

  # see labels.pdf.prawn for box position calculations
  X_POS_LEFT_BOX = 0
  X_POS_RIGHT_BOX = 288 + 8 # to allow 16 points of space down vertical centre
  Y_POS_TOP_BOX = 826
  HALF_HEIGHT = 413
  Y_POS_BOTTOM_BOX = HALF_HEIGHT - 4 # to allow 8 points of space across the horizontal centre

  CURRENT_BOX_ZERO = 0

  def generate_label(pdf, current_page, formatter)

    header = "<b>#{Setting.instance.app_title} (#{Setting.instance.specimen_prefix})<b>"
    header = "<b><i>ex</i></b> " + header if formatter.show_ex?
    institution = Setting.instance.institution
    address = Setting.instance.institution_address
    notification = "Notification of change of determination would be appreciated by #{Setting.instance.specimen_prefix}"

    pdf.text header,      :inline_format => true, :align => :center
    pdf.text institution, :align => :center
    pdf.text address,     :align => :center
    pdf.move_down 2

    pdf.text notification, :size => 8, :align => :center
    pdf.move_down 10
    pdf.text formatter.accession_number, :style => :bold

    sheet_text = formatter.sheet(current_page)
    if (!sheet_text.empty?)
      pdf.move_up 12
      pdf.text sheet_text, :align => :right, :inline_format => true
    end
    pdf.move_down 10

    pdf.text formatter.family_sub_family, :inline_format => true
    pdf.move_down 10

    tribe(pdf, formatter)

    hanging_indent(pdf, formatter.genus_species_and_authority)

    subspecies_line = formatter.subspecies_and_authority
    if !subspecies_line.empty?
      hanging_indent(pdf, subspecies_line)
    end

    variety_line = formatter.variety_and_authority
    if !variety_line.empty?
      hanging_indent(pdf, variety_line)
    end

    form_line = formatter.form_and_authority
    if !form_line.empty?
      hanging_indent(pdf, form_line)
    end

    pdf.move_down 10

    pdf.text formatter.locality_botanical_division_locality_description, :inline_format => true

    pdf.move_down 10
    pdf.text formatter.latitude_longitude
    pdf.move_up 12
    pdf.text formatter.datum_altitude, :align => :right

    pdf.move_down 10
    pdf.text formatter.topography_aspect_substrate_vegetation, :inline_format => true

    pdf.move_down 10
    pdf.text formatter.frequency_plant_description

    pdf.move_down 10
    pdf.text formatter.items

    pdf.move_down 10
    pdf.text formatter.collector, :inline_format => true

    collection_date_line = formatter.collection_date
    if !collection_date_line.empty?
      pdf.move_up 12
      pdf.text collection_date_line, :align => :right
    end

    secondary_collectors(pdf, formatter)
    pdf.move_down 10
    pdf.text formatter.determiners
    pdf.text formatter.determination_date, :align => :right
    pdf.move_down 10
    pdf.text formatter.replicates

    # add a barcode
    barcode_value = formatter.barcode_value
    barcode_label = formatter.barcode_label

    barcode = Barby::Code39.new(barcode_value)
    # the calculations here are a little hard to follow:
    # we're creating a new bounding box for the image which is relative to the surrounding box
    # STEP 1: we move down 30 (as this is the size of the image) so our box autostretches to give us space for the image
    # STEP 2: create the bounding box for the image
    #     y co-ordinate set to 30 since this will put its top-left corner 30 above the bottom of the box
    #     x co-ordinate set to 0 so its left aligned
    current_width = pdf.bounds.width
    barcode_height = 30

    pdf.move_down(barcode_height + 2)

    pdf.bounding_box [0, barcode_height], :width => current_width, :height => barcode_height do
      barcode.annotate_pdf(pdf, :height => barcode_height)
    end
    pdf.move_down 2
    pdf.text barcode_label, :size => 6

    current_box_height = pdf.bounds.top
    return current_box_height
  end

  def new_page(pdf)
    pdf.start_new_page
  end

  # position of the four boxes - position is defined by the top left corner, the coordinates start from the left and bottom of the page
  def box_values
    boxes = [ [X_POS_LEFT_BOX, Y_POS_TOP_BOX], [X_POS_RIGHT_BOX, Y_POS_TOP_BOX], [X_POS_LEFT_BOX, Y_POS_BOTTOM_BOX], [X_POS_RIGHT_BOX, Y_POS_BOTTOM_BOX] ]
    return boxes
  end

  def tribe(pdf, formatter)
    tribe = formatter.tribe
    if (!tribe.blank?)
      pdf.text tribe, :inline_format => true
      pdf.move_down 10
    end
  end

  def secondary_collectors(pdf, formatter)
    if !formatter.specimen.secondary_collectors.empty?
      pdf.text "#{formatter.specimen.secondary_collectors_comma_separated}", :indent_paragraphs => 30
    end
  end

  private
  def hanging_indent(pdf, line)
    pdf.text line, :inline_format => true, :overflow => :shrink_to_fit
  end
  
end
