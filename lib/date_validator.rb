# To use:
# validates_with DateValidator, :field_name => 'data_name_field', :fields => {day=>:day_field, month=>month_field, year=>:year_field}
# append :validate_legacy => 'is_legacy?'

# check that if legacy, year is not a requirement but optional
class DateValidator < ActiveModel::Validator

  def validate(record)
    if record[options[:legacy_data]] == true
      if not_empty? record[options[:fields][:month]] or not_empty? record[options[:fields][:day]] and empty?(record[options[:fields][:year]])
        record.errors[:base] << "Enter a year for #{options[:field_name]}"
        # check that the month field is not empty if a day is filled in
      elsif empty? record[options[:fields][:month]] and not_empty? record[options[:fields][:day]]
        record.errors[:base] << "Enter a month for #{options[:field_name]}"
      else
        # if a day and month are included check if day is valid in given month
        if !empty? (record[options[:fields][:month]]) and !empty?(record[options[:fields][:day]])
          days_in_month = days_in_month(record[options[:fields][:month]], record[options[:fields][:year]])
          if record[options[:fields][:day]] > days_in_month
            record.errors[:base] << "You have entered an invalid day for the given month for #{options[:field_name]}"
          end
        end
      end
    elsif !options[:field_name].eql?("Date of birth") and !options[:field_name].eql?("Date of death")
      if empty?(record[options[:fields][:year]])
        record.errors[:base] << "Enter a year for #{options[:field_name]}"
      # check that the month field is not empty if a day is filled in
      elsif empty? record[options[:fields][:month]] and not_empty? record[options[:fields][:day]]
        record.errors[:base] << "Enter a month for #{options[:field_name]}"
      else
        # if a day and month are included check if day is valid in given month
        if !empty?(record[options[:fields][:month]]) and !empty? (record[options[:fields][:day]]) 
          days_in_month = days_in_month(record[options[:fields][:month]], record[options[:fields][:year]])
          if record[options[:fields][:day]] > days_in_month
            record.errors[:base] << "You have entered an invalid day for the given month for #{options[:field_name]}"
          end
        end
      end
    else 
      if not_empty? record[options[:fields][:month]] or not_empty? record[options[:fields][:day]] and empty?(record[options[:fields][:year]])
        record.errors[:base] << "Enter a year for #{options[:field_name]}"
      # check that the month field is not empty if a day is filled in
      elsif empty? record[options[:fields][:month]] and not_empty? record[options[:fields][:day]]
        record.errors[:base] << "Enter a month for #{options[:field_name]}"
      else
        # if a day and month are included check if day is valid in given month
        if !empty?(record[options[:fields][:month]]) and !empty?(record[options[:fields][:day]])
          days_in_month = days_in_month(record[options[:fields][:month]], record[options[:fields][:year]])
          if record[options[:fields][:day]] > days_in_month
            record.errors[:base] << "You have entered an invalid day for the given month for #{options[:field_name]}"
          end
        end
      end
    end
  end

  private
  
  # from ActiveSupport::CoreExtensions::Time
  def days_in_month(month, year)
    if month == 2
      !year.nil? && (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0)) ?  29 : 28
    elsif month <= 7
      month % 2 == 0 ? 30 : 31
    else
      month % 2 == 0 ? 31 : 30
    end
  end

  def empty?(str)
    not not_empty?(str)
  end

  def not_empty?(str)
    str != nil && str.to_i > 0
  end
end 

