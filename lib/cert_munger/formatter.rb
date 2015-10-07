require 'logging'

# Custom exception for strings that can't be parsed as X509 Certificates
class UnparsableCertError < TypeError; end

#
# CertMunger accepts an input string and attempts to return a valid X509
# formatted certificate.
#
module CertMunger
  # Enables `include CertMunger` to also extend class methods
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Instance variable accessor for CertMunger#to_cert
  def to_cert(raw_cert)
    self.class.send(:to_cert, raw_cert)
  end

  #
  # Class methods provided by CertMunger module
  #
  module ClassMethods
    # logger method to return Rails logger if defined, else logging logger
    def logger
      return @logger if @logger
      logger = Logging.logger[self] unless @logger
      @logger ||= Kernel.const_defined?('Rails') ? Rails.logger : logger
    end

    # Attempts to munge a string into a valid X509 certificate
    #
    # @param raw_cert [String] The string of text you wish to parse into a cert
    # @return [OpenSSL::X509::Certificate]
    def to_cert(raw_cert)
      logger.debug "CertMunger raw_cert:\n#{raw_cert}"
      new_cert = build_cert(raw_cert)
      logger.debug "CertMunger reformatted_cert:\n#{new_cert}"
      logger.debug 'Returning OpenSSL::X509::Certificate.new on new_cert'

      OpenSSL::X509::Certificate.new new_cert
    end

    # Creates a temporary cert and orchestrates certificate body reformatting
    #
    # @param raw_cert [String] The string of text you wish to parse into a cert
    # @return [String] reformatted and (hopefully) parseable certificate string
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

    # Attempts to reformat one-line certificate bodies
    #
    # @param raw_cert [String] The string of text you wish to parse into a cert
    # @return [String] reformatted certificate body
    def one_line_contents(raw_cert)
      # Detect if we have newlines, if not, split on spaces
      if raw_cert.include?('\n')
        cert_contents = raw_cert.split('\n')
      else
        cert_contents = parse_space_delimited_cert(raw_cert)
      end
      cert_contents.pop   # Remove -----BEGIN CERTIFICATE-----
      cert_contents.shift # Remove -----END CERTIFICATE-----

      cert_contents.map! { |el| el.match('\W+[t|n|r](.*)')[1] }
    end

    # Attempts to reformat one-line certificate bodies
    #
    # @param raw_cert [String] The string of text you wish to parse into a cert
    # @return [Array] reformatted certificate content in Array format
    def parse_space_delimited_cert(raw_cert)
      cert_contents = raw_cert.split(' ')
      # "-----BEGIN CERTIFICATE------" fix
      cert_contents[0] += " #{cert_contents.delete_at(1)}"
      # "-----END CERTIFICATE------" fix
      cert_contents[-1] = "#{cert_contents[-2]} #{cert_contents.delete_at(-1)}"

      cert_contents.map { |el| "\\t#{el}" } # Hack it to match expected syntax
    end

    # Attempts to reformat multi-line certificate bodies
    #
    # @param raw_cert [String] The string of text you wish to parse into a cert
    # @return [String] reformatted certificate body
    def multi_line_contents(raw_cert)
      cert_contents = raw_cert.split(/[-](.*)[-]/)[2]
      cert_contents.lines.map do |line|
        line.lstrip.squeeze(' ').split(' ')
      end
    end
  end
end
