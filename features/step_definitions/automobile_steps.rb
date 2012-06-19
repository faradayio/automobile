When /^(make_model(_year)?) is determined$/ do |characteristic, _|
  result = if @characteristics[:make] and @characteristics[:model]
    if characteristic == 'make_model'
      AutomobileMakeModel.where(:make_name => @characteristics[:make].name, :model_name => @characteristics[:model].name).first
    elsif @characteristics[:year]
      AutomobileMakeModelYear.where(:make_name => @characteristics[:make].name, :model_name => @characteristics[:model].name, :year => @characteristics[:year].year).first
    end
  end
  @characteristics[characteristic.to_sym] = result unless result.nil?
end
