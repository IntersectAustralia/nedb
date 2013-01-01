module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def format_partial_date(year,month,day)
    date_string = ""
    date_string << (day.to_s + " ") if day
    if month
      month_string = Date::MONTHNAMES[month]
      if (month_string.length > 4)
        month_string = month_string[0,3] + "."
      end
      date_string << month_string + " "
    end
    date_string << year.to_s
    date_string
  end
  
  def format_partial_date_for_csv(year,month,day)
    date_string = ""
    date_string << (day.to_s + " ") if day
    if month
      month_string = Date::MONTHNAMES[month]
      if (month_string.length > 3)
        month_string = month_string[0,3]
      end
      date_string << month_string + " "
    end
    date_string << year.to_s
    date_string
  end

  # convenience method to render a field on a view screen - saves repeating the div/span etc each time
  def render_field(label, value)
    render_field_content(label, (h value))
  end

  def render_field_if_not_empty(label, value)
    render_field_content(label, (h value)) if value != nil && !value.empty?
  end
  
  def button_to_if(condition, label, link)
    button_to(label, link) if condition
  end

  def icon(type)
    "<span class='icon_#{type}'></span>&nbsp;".html_safe
  end

  # as above but takes a block for the field value
  def render_field_with_block(label, &block)  
    content = with_output_buffer(&block)
    render_field_content(label, content)
  end
  
  def has_any_admin_rights?
    return can?(:read, Person) || can?(:read, Herbarium) || can?(:read, User) || can?(:view_access_requests, User) || can?(:view_needing_review, Specimen) || can?(:read, Species)
  end

  private
  def render_field_content(label, content)
    div_class = cycle("field_bg","field_nobg")
    div_id = label.tr(" ,", "_").downcase
    html = "<div class='#{div_class} inlineblock' id='display_#{div_id}'>"
    html << '<span class="label_view">'
    html << (h label)
    html << ":"
    html << '</span>'
    html << '<span class="field_value">'
    html << content
    html << '</span>'
    html << '</div>'
    html.html_safe
  end


end
