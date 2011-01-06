require 'helper'

class TestCdrFetcher < Test::Unit::TestCase
  context "A CDR Fetcher instance" do
    setup do
      @cdr_directory = {
        "01-01-01" => ["Master.csv.1234567890"],
        "01-01-02" => ["Master.csv.1234567891","Master.csv.1234567892"]
      }
    end
  end
end
