#!/usr/bin/env ruby

require 'digest/sha2'
built_gem_path = "pkg/cert_munger-#{ENV['VERSION']}.gem"
checksum = Digest::SHA512.new.hexdigest(File.read(built_gem_path))
checksum_path = "checksum/cert_munger-#{ENV['VERSION']}.gem.sha512"
File.open(checksum_path, 'w') { |f| f.write(checksum) }
