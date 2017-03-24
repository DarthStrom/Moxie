Pod::Spec.new do |s|
  s.name = "MockingBird"
  s.version = "0.1.1-alpha"
  s.summary = "A mocking library for Swift."
  s.description = <<-DESC
    MockingBird makes creating mocks easier in Swift.
    DESC
  s.homepage = "https://github.com/DarthStrom/MockingBird"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Jason Duffy" => "jasonsduffy@gmail.com" }
  s.social_media_url = "http://twitter.com/DarthStrom"
  s.source = { :git => "https://github.com/DarthStrom/MockingBird.git", :tag => "v#{s.version}" }
  s.source_files = "Sources", "Sources"
  s.osx.deployment_target = '10.10'
end
