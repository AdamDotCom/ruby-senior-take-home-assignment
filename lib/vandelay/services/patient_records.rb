module Vandelay
  module Services
    class PatientRecords
      include Vandelay::Integrations

      def initialize(cache = Vandelay.cache)
        @cache = cache
      end

      def retrieve_record_for_patient(patient)
        return JSON.parse(@cache.get(patient.id)) if @cache.exists?(patient.id)

        result = consolidate_from_services(patient)

        @cache.set(patient.id, result.to_json)
        @cache.expire(patient.id, 600)
        result
      end

      def consolidate_from_services(patient)
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