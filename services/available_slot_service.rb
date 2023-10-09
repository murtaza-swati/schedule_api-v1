class AvailableSlotService
  def self.call(*args)
    new(*args).call
  end

  def initialize(doctor, start_time: Date.current, end_time: Date.current + 7.days)
    @doctor = doctor
    @start_time = start_time
    @end_time = end_time
    @result = {}
  end

  # Returns a hash containing available slots for a given doctor between start_time and end_time
  #
  # @return [Hash] A hash containing available slots for a given doctor between start_time and end_time
  def call
    return @result if @result.present?

    (@start_time..@end_time).each do |date|
      working_hours = [(convert_to_time(date, @doctor.work_start_time)..convert_to_time(date, @doctor.work_end_time))]
      appointments = find_appointments_for(date)
      unless appointments.empty?
        appointments.each do |appointment|
          occupied_range = (appointment.start_time..(appointment.start_time + @doctor.slot_duration.minutes + @doctor.break_duration.minutes))

          working_hours[-1] = subtract_ranges(working_hours[-1], occupied_range)
          working_hours.flatten!
        end

        working_hours.map { |range| format_range(range) }
      end
      @result[date.strftime("%d-%m-%Y")] = working_hours.map { |range| format_range(range) }
    end

    @result
  end

  private

  # Converts a given date and time to a Time object
  #
  # @param date [Date] The date to convert
  # @param time [Time] The time to convert
  # @return [Time] The converted Time object
  def convert_to_time(date, time)
    Time.new(date.year, date.month, date.day, time.hour, time.min, 0)
  end

  # Finds appointments for a given date
  #
  # @param date [Date] The date to find appointments for
  # @return [ActiveRecord::Relation] An ActiveRecord relation containing appointments for the given date
  def find_appointments_for(date)
    @doctor.appointments.where("DATE(start_time) = ?", date).order(:start_time)
  end

  # Subtracts an occupied range from a given range
  #
  # @param range [Range] The range to subtract from
  # @param occupied [Range] The occupied range to subtract
  # @return [Array<Range>] An array of ranges representing the available slots
  def subtract_ranges(range, occupied)
    ranges = []

    if range.include?(occupied)
      ranges += divide_range(range, occupied)
    end

    ranges
  end

  # Divides a given range into two ranges separated by a gap
  #
  # @param range [Range] The range to divide
  # @param gap [Range] The gap to divide the range by
  # @return [Array<Range>] An array of ranges representing the divided range
  def divide_range(range, gap)
    ranges = []
    # Check if there is possibility to add appointment before gap
    if gap.begin - range.begin >= (@doctor.slot_duration.minutes + @doctor.break_duration.minutes)
      ranges << (range.begin..gap.begin)
    end

    # Check if there is possibility to add appointment after gap
    if range.end - gap.end >= @doctor.slot_duration.minutes
      ranges << (gap.end..range.end)
    end

    ranges
  end

  # Formats a given range to a string
  #
  # @param range [Range] The range to format
  # @return [String] A string representing the formatted range
  def format_range(range)
    "#{format_time(range.begin)} - #{format_time(range.end)}".squeeze(" ")
  end

  # Formats a given time to a string
  #
  # @param time [Time] The time to format
  # @return [String] A string representing the formatted time
  def format_time(time)
    time.strftime("%I:%M %p").strip
  end
end
