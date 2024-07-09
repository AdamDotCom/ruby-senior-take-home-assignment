require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patient_records_srvc
        @patient_records_srvc ||= Vandelay::Services::PatientRecords.new
      end

      def self.registered(app)
        app.get '/patients/:id' do
          patient = Vandelay::Models::Patient.find_by_id!(params[:id])
          json(patient)
        end

        app.get '/patients/:id/vendor' do
          patient = Vandelay::Models::Patient.find_by_id!(params[:id])

          results = Vandelay::REST::PatientsPatient.patient_records_srvc.retrieve_record_for_patient(patient)
          json(results)
        end
      end
    end
  end
end
