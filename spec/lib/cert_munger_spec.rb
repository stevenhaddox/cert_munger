require "spec_helper"
require "openssl"

describe CertMunger do
  let(:class_including_cert_munger) {
    Class.new do
      include CertMunger
      Logging.logger[self].level = :warn
    end
  }

  subject                     { class_including_cert_munger.new }
  let!(:raw_cert)             { File.read("spec/certs/ruby_user.crt") }
  let(:pub_key)               { File.read("spec/certs/ruby_user.pub") }
  let!(:certificate)          { OpenSSL::X509::Certificate.new(raw_cert) }
  let!(:malformed_cert)       { File.read("spec/certs/malformed.crt") }
  let!(:one_line_cert)        { File.read("spec/certs/one_line.crt") }
  let!(:one_line_spaces_cert) { File.read("spec/certs/one_line_spaces.crt") }
  let!(:passenger_nginx_cert) { File.read("spec/certs/passenger.crt") }

  #
  # Unit specs
  #

  describe ".to_cert" do
    it "should parse a certificate with invalid spacing/newlines" do
      new_cert = subject.to_cert(malformed_cert)
      expect(new_cert.to_s).to eq(certificate.to_s)
    end

    it "should parse a certificate with passenger formatted spacing/newlines" do
      new_cert = subject.to_cert(passenger_nginx_cert)
      expect(new_cert.to_s).to eq(certificate.to_s)
    end

    it "should parse a certificate with all content in one line" do
      new_cert = subject.to_cert(one_line_cert)
      expect(new_cert.to_s).to eq(certificate.to_s)
    end

    it "should parse a certificate with all content in one line, space delimited" do
      new_cert = subject.to_cert(one_line_spaces_cert)
      expect(new_cert.to_s).to eq(certificate.to_s)
    end
  end

  describe "#to_cert" do
    it "should parse a certificate with invalid spacing/newlines" do
      new_cert = subject.class.send(:to_cert, malformed_cert)
      expect(new_cert.to_s).to eq(certificate.to_s)
    end

    it "should parse a certificate with passenger formatted spacing/newlines" do
      new_cert = subject.class.send(:to_cert, passenger_nginx_cert)
      expect(new_cert.to_s).to eq(certificate.to_s)
    end

    it "should parse a certificate with all content in one line" do
      new_cert = subject.class.send(:to_cert, one_line_cert)
      expect(new_cert.to_s).to eq(certificate.to_s)
    end
  end
end
