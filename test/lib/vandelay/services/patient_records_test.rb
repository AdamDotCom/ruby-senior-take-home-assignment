require_relative '../../../../lib/vandelay/integrations'
require_relative '../../../../lib/vandelay/services/patient_records'

class PatientRecordsTest < Minitest::Test
  include Vandelay::Services

  def setup
    @patient = OpenStruct.new({ id: 1 })
    @service_result = {
      'patient_id' => @patient.id,
      'allergies' => nil,
      'num_medical_visits' => nil,
      'province' => nil,
    }
  end

  def test_cache_miss
    @mock = Minitest::Mock.new
    @mock.expect(:exists?, false, [@patient.id])
    @mock.expect(:set, nil, [@patient.id, @service_result.to_json])
    @mock.expect(:expire, nil, [@patient.id, 600])

    PatientRecords.new(@mock).retrieve_record_for_patient(@patient)

    @mock.verify
  end

  def test_cache_result
    @mock = Minitest::Mock.new
    @mock.expect(:exists?, true, [@patient.id])
    @mock.expect(:get, @service_result.to_json, [@patient.id])

    PatientRecords.new(@mock).retrieve_record_for_patient(@patient)

    @mock.verify
  end
end