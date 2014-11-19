#
# Extend the core String class to include `.to_cert` && `.to_cert!`
#
class String
  include CertMunger

  # Returns an X509 certificate after parsing the value of this object.
  # Returns false if an X509 certificate cannot be created
  def to_cert
    begin
      new_cert = self.class.send(:to_cert, self)
    rescue StandardError
      new_cert = false
    end

    new_cert
  end

  # Similar to {#to_cert}, but raises an error unless the string can be
  # explicitly parsed to an X509 certifcate
  def to_cert!
    begin
      new_cert = self.class.send(:to_cert, self)
    rescue StandardError
      raise UnparsableCertError,
            "Could not force conversion to X509:\n#{inspect}"
    end

    new_cert
  end
end
