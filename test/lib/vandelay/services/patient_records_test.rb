require_relative '../../../../lib/vandelay/integrations'
require_relative '../../../../lib/vandelay/services/patient_records'

class PatientRecords < Test::Unit::TestCase
  include Vandelay::Services

  def test_vendor_two_extension
    VCR.use_cassette("vendor_two") do
      patient = OpenStruct.new(
        {
          id: 3,
          records_vendor: 'two',
          vendor_id: 16
        }
      )
      expectation = {
        'patient_id' => 3,
        'allergies' => ["hair", "mean people", "paying the bill"],
        'num_medical_visits' => 17,
        'province' => "ON"
      }
      assert_equal expectation, PatientRecords.new.retrieve_record_for_patient(patient)
    end
  end

  def test_vendor_one_extension
    VCR.use_cassette("vendor_one") do
      patient = OpenStruct.new(
        {
          id: 2,
          records_vendor: 'one',
          vendor_id: 743
        }
      )
      expectation =
        {
          'patient_id' => 2,
          'allergies' => ["work", "conformity", "paying taxes"],
          'num_medical_visits' => nil,
          'province' => "QC",
        }
      assert_equal expectation, PatientRecords.new.retrieve_record_for_patient(patient)
    end
  end

  def test_no_vendor
    patient = OpenStruct.new(
      {
        id: 1,
        records_vendor: nil,
        vendor_id: nil
      }
    )
    expectation =
      {
        'patient_id' => 1,
        'allergies' => nil,
        'num_medical_visits' => nil,
        'province' => nil,
      }
    assert_equal expectation, PatientRecords.new.retrieve_record_for_patient(patient)
  end
end