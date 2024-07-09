require_relative '../../../../lib/vandelay/integrations'

class VCRTest < Test::Unit::TestCase
  include Vandelay::Integrations

  def test_patients_cosmo
    VCR.use_cassette("vendor_one") do
      config = { 'integrations' => { 'vendors' => { 'one' => { 'api_base_url' => 'mock_api_one:80' }}}}

      cosmo = VendorOneClient.new(config).patients(743)[0]
      expectation = {
        "allergies" => ["work", "conformity", "paying taxes"],
        "dob" => "1987-03-18",
        "full_name" => "Cosmo Kramer",
        "id" => "743",
        "province" => "QC",
        "recent_medical_visits" => 1
      }
      assert_equal expectation, cosmo
    end
  end
end