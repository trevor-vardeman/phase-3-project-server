class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get "/" do
  end

  get "/appointments" do
    Appointment.upcoming_appointments.to_json(include: [:service, :dog, :groomer])
  end

  get "/appointments/:id" do
    appointment = Appointment.find(params[:id])
    appointment.to_json(include: [:service, :dog, :groomer])
  end

  delete "/appointments/:id" do
    appointment = Appointment.find(params[:id])
    appointment.destroy
    appointment.to_json
  end

  get "/create-appointment" do
    dogs = Dog.all.where(archived: false)
    groomers = Groomer.all.where(offboarding_date: "")
    services = Service.all.where(archived: false)

    data = dogs, groomers, services
    data.to_json
  end

  get "/appointments/:id/edit" do
    dogs = Dog.all
    groomers = Groomer.all
    services = Service.all

    data = dogs, groomers, services
    data.to_json
  end

  patch "/appointments/:id/edit" do
    appointment = Appointment.find(params[:id])
    appointment.update(
      dog_id: params[:dog_id],
      groomer_id: params[:groomer_id],
      appt_datetime: params[:appt_datetime],
      service_id: params[:service_id]
    )
    appointment.to_json
  end

  post "/create-appointment" do
    appointment = Appointment.create(
      dog_id: params[:dog_id],
      groomer_id: params[:groomer_id],
      appt_datetime: params[:appt_datetime],
      service_id: params[:service_id]
    )
    appointment.to_json
  end

  get "/past-appointments" do
    Appointment.past_appointments.to_json(include: [:service, :dog, :groomer])
  end

  get "/dogs" do
    dogs = Dog.all.where(archived: false)
    dogs.to_json
  end

  patch "/dogs/:id" do
    dog = Dog.find(params[:id])
    dog.update(archived: params[:archived])
    dog.to_json
  end

  post "/create-dog" do
    dog = Dog.create(
      name: params[:name],
      breed: params[:breed],
      age: params[:age],
      photo_url: params[:photo_url],
      archived: params[:archived]
    )
    dog.to_json
  end

  get "/archived-dogs" do
    dogs = Dog.all.where(archived: true)
    dogs.to_json
  end

  get "/groomers" do
    groomers = Groomer.all.where(offboarding_date: "")
    groomers.to_json
  end

  get "/groomers/:id" do
    groomer = Groomer.find(params[:id])
    groomer.to_json
  end

  patch "/groomers/:id/edit" do
    groomer = Groomer.find(params[:id])
    groomer.update(
      name: params[:name],
      onboarding_date: params[:onboarding_date],
      offboarding_date: params[:offboarding_date]
    )
    groomer.to_json
  end

  get "/offboarded-groomers" do
    groomers = Groomer.all.where.not(offboarding_date: "")
    groomers.to_json
  end

  post "/create-groomer" do
    groomer = Groomer.create(
      name: params[:name],
      onboarding_date: params[:onboarding_date],
      offboarding_date: params[:offboarding_date]
    )
    groomer.to_json
  end

  get "/services" do
    services = Service.where(archived: false)
    services.to_json
  end

  patch "/services/:id" do
    service = Service.find(params[:id])
    service.update(archived: params[:archived])
    service.to_json
  end

  get "/archived-services" do
    services = Service.where(archived: true)
    services.to_json
  end

  post "/create-service" do
    service = Service.create(
      name: params[:name],
      description: params[:description],
      cost: params[:cost],
      service_length: params[:service_length],
      archived: params[:archived]
    )
    service.to_json
  end
end