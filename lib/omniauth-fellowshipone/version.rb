module OmniAuth
  module FellowshipOne
    module Version
      MAJOR = 0 unless defined? ::OmniAuth::FellowshipOne::Version::MAJOR
      MINOR = 1 unless defined? ::OmniAuth::FellowshipOne::Version::MINOR
      PATCH = 0 unless defined? ::OmniAuth::FellowshipOne::Version::PATCH
      STRING = [MAJOR, MINOR, PATCH].join('.') unless defined? ::OmniAuth::FellowshipOne::Version::STRING
    end
  end
end
