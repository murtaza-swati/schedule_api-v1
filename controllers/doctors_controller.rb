class DoctorsController
  def self.call(method, params)
    doctor = Doctor.where(id: params[:doctor_id]).first_or_initialize
    new(doctor).public_send(method)
  end

  def initialize(doctor)
    self.doctor = Doctor::Presenter.new(doctor)
  end

  delegate :availability, to: :doctor

  private

  attr_accessor :doctor
end
