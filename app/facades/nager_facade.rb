class NagerFacade

  def self.generate_holidays
    holidays = NagerService.get_holidays
    holidays[0..2].map { |holiday| Holidays.new(holiday) }
  end
end