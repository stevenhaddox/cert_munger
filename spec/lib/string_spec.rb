require 'spec_helper'

describe String do
  let!(:raw_cert)             { File.read("spec/certs/ruby_user.crt") }
  let!(:certificate)          { OpenSSL::X509::Certificate.new(raw_cert) }
  let!(:malformed_cert)       { File.read("spec/certs/malformed.crt") }
  let!(:one_line_cert)        { File.read("spec/certs/one_line.crt") }
  let!(:passenger_nginx_cert) { File.read("spec/certs/passenger.crt") }

  after :all do
    expect(@log_output.readline).to eq("DEBUG  String : CertMunger raw_cert:\n")
  end

  describe ".to_cert" do
    it "should return an X509 certificate if the string can be parsed" do
      expect(passenger_nginx_cert.to_cert.to_s).to eq(certificate.to_s)
      expect(malformed_cert.to_cert.to_s).to eq(certificate.to_s)
      expect(one_line_cert.to_cert.to_s).to eq(certificate.to_s)
    end

    it "should return false otherwise" do
      expect("".to_cert).to eql(false)
      expect("nope".to_cert).to eql(false)
    end
  end

  describe ".to_cert!" do
    it "should return an X509 certificate if the string can be parsed" do
      expect(passenger_nginx_cert.to_cert!.to_s).to eq(certificate.to_s)
      expect(malformed_cert.to_cert!.to_s).to eq(certificate.to_s)
      expect(one_line_cert.to_cert!.to_s).to eq(certificate.to_s)
    end

    it "should raise an UnparsableCert error otherwise" do
      expect{ "".to_cert! }.to raise_error(UnparsableCertError)
      expect{ "nope".to_cert! }.to raise_error(UnparsableCertError)
    end
  end
end
