MetaSearch::Where.add :between, :btw,
                      :predicate => :in,
                      :types => [:integer, :float, :decimal, :date, :datetime, :timestamp, :time],
                      :formatter => Proc.new {|param| Range.new(param.first, param.last)},
                      :validator => Proc.new {|param|
                        param.is_a?(Array) && !(param[0].blank? || param[1].blank?)
                      }

MetaSearch::Where.add :date_from ,
                      :predicate => :in,
                      :types => [:integer],
                      :formatter => Proc.new {|param| Range.new(param.first, param.last)},
                      :validator => Proc.new {|param|
                        param.is_a?(Array) && !(!param[0].blank? && (param[1].blank? || param[2].blank?)) && !(!param[1].blank? && param[2].blank?)
                      }

MetaSearch::Where.add :date_to ,
                      :predicate => :in,
                      :types => [:integer],
                      :formatter => Proc.new {|param| Range.new(param.first, param.last)},
                      :validator => Proc.new {|param|
                        param.is_a?(Array) && !(!param[0].blank? && (param[1].blank? || param[2].blank?)) && !(!param[1].blank? && param[2].blank?)
                      }