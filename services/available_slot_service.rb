class AvailableSlotService
  def self.call(*args)
    new(*args).call
  end

  def initialize(doctor, start_time: Date.current, end_time: Date.current + 7.days)
    self.doctor = doctor
    self.start_time = start_time
    self.end_time = end_time
  end

  def call

  end

  private

  attr_accessor :doctor, :start_time, :end_time
end
