require 'logging'
class UnparsableCertError < TypeError; end

#
# CertMunger accepts an input string and attempts to return a valid X509
# formatted certificate.
#
module CertMunger
  def self.included(base)
    base.extend(ClassMethods)
  end

  def to_cert(raw_cert)
    self.class.send(:to_cert, raw_cert)
  end

  #
  # Extended class methods via `include CertMunger`
  #
  module ClassMethods
    def logger
      return @logger if @logger
      logger = Logging.logger[self] unless @logger
      @logger ||= Kernel.const_defined?('Rails') ? Rails.logger : logger
    end

    def to_cert(raw_cert)
      logger.debug "CertMunger raw_cert:\n#{raw_cert}"
      new_cert = build_cert(raw_cert)
      logger.debug "CertMunger reformatted_cert:\n#{new_cert}"
      logger.debug 'Returning OpenSSL::X509::Certificate.new on new_cert'

      OpenSSL::X509::Certificate.new new_cert
    end

    def build_cert(raw_cert)
      tmp_cert = ['-----BEGIN CERTIFICATE-----']
      if raw_cert.lines.count == 1
        cert_contents = one_line_contents(raw_cert)
      else
        cert_contents = multi_line_contents(raw_cert)
      end
      tmp_cert << cert_contents.flatten # put mixed space lines as own elements
      tmp_cert << '-----END CERTIFICATE-----'
      tmp_cert.join("\n").rstrip
    end

    def one_line_contents(raw_cert)
      cert_contents = raw_cert.split('\n')
      cert_contents.pop
      cert_contents.shift
      cert_contents.map! { |el| el.match('\W+[t|n|r](.*)')[1] }
    end

    def multi_line_contents(raw_cert)
      cert_contents = raw_cert.split(/[-](.*)[-]/)[2]
      cert_contents.lines.map do |line|
        line.lstrip.squeeze(' ').split(' ')
      end
    end
  end
end
