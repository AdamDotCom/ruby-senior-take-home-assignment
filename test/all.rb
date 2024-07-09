require 'rubygems'
require 'minitest/autorun'
require 'vcr'
require_relative '../lib/vandelay'

Dir[File.dirname(File.absolute_path(__FILE__)) + '/**/*_test.rb'].each {|file| require file }

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end