require_relative '../../../../lib/vandelay/integrations'

class VCRTest < Test::Unit::TestCase
  include Vandelay::Integrations

  def test_records_george
    VCR.use_cassette("vendor_two") do
      config = { 'integrations' => { 'vendors' => { 'two' => { 'api_base_url' => 'mock_api_two:80' }}}}

      george = VendorTwoClient.new(config).records(16)[0]
      expectation = {
        "allergies_list" => ["hair", "mean people", "paying the bill"],
        "birthdate" => "1984-09-07",
        "clinic_id" => "7",
        "id" => "16",
        "medical_visits_recently" => 17,
        "name" => "George Costanza",
        "province_code" => "ON"
      }
      assert_equal expectation, george
    end
  end
end