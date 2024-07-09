module Vandelay
  module Services
    class PatientRecords
      include Vandelay::Integrations

      def retrieve_record_for_patient(patient)
        result = {
          'patient_id' => patient.id,
          'allergies' => nil,
          'num_medical_visits' => nil,
          'province' => nil,
        }

        case patient.records_vendor
        when 'one'
          response = VendorOneClient.new(Vandelay.config).patients(patient.vendor_id)[0]
          result.merge!(response.slice('province', 'allergies'))
        when 'two'
          response = VendorTwoClient.new(Vandelay.config).patients(patient.vendor_id)[0]
          result.merge!(
            {
              'allergies' => response['allergies_list'],
              'num_medical_visits' => response['medical_visits_recently'],
              'province' => response['province_code'],
            }
          )
        end

        result
      end
    end
  end
end