# A4 paper is 842x595 points. 
# The page margins are
# top: 8, bottom: 8, left: 10, right: 9
# Therefore our main box is 826x576.
# This is divided into four boxes. Mid points are 413 and 288
# To allow 16 points of space down the vertical centre line, each box is only 280 wide.
# To allow 8 points of space in the horizontal centre line, each box is only 409 high.

# NOTE: margins are set in the controller: :left_margin => 10, :right_margin => 9, :top_margin => 8, :bottom_margin => 8


box_width = 280

pdf.font_size 10

current_box = -1
current_height = 0

pdf_creator = SpecimenPdfCreator.new

@specimens.each do |specimen|
  items_requiring_labels = specimen.items.requiring_labels
  specimen_sheets = items_requiring_labels.find_all { |item| item.item_type.name == ItemType::TYPE_SPECIMEN_SHEET }
  other_items = items_requiring_labels.find_all { |item| item.item_type.name != ItemType::TYPE_SPECIMEN_SHEET }
  items_in_order = specimen_sheets + other_items

  items = items_in_order.map { |item| ItemLabelFormatter.new(specimen, item) }
  replicates = specimen.replicates.map { |rep| ReplicateLabelFormatter.new(specimen, rep) }

  current_label_number = 0
  items.each do |item_formatter|
    current_box = current_box + 1
    current_label_number = current_label_number + 1

    current_box = pdf_creator.layout_boxes(pdf, current_height, current_box)

    # draw the bounding box
    pdf.bounding_box(pdf_creator.box_values[current_box], :width => box_width) do
      current_height = pdf_creator.generate_label(pdf, current_label_number, item_formatter)
    end
  end

  replicates.each do |rep_formatter|
    current_box = current_box + 1

    current_box = pdf_creator.layout_boxes(pdf, current_height, current_box)

    # draw the bounding box
    pdf.bounding_box pdf_creator.box_values[current_box], :width => box_width do
      current_height = pdf_creator.generate_label(pdf, 0, rep_formatter)
    end
  end

end