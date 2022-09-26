class Holidays
  attr_reader :name, :date

  def initialize(holiday)
    @name = holiday[:name]
    @date = holiday[:date]
  end
end