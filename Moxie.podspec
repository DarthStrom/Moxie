Pod::Spec.new do |s|
  s.name = "Moxie"
  s.version = "0.1.6"
  s.summary = "A mocking library for Swift."
  s.description = <<-DESC
    Moxie makes creating mocks easier in Swift.
    DESC
  s.homepage = "https://github.com/DarthStrom/Moxie"
  s.license = 'MIT'
  s.author = { "Jason Duffy" => "jasonsduffy@gmail.com" }
  s.social_media_url = "http://twitter.com/DarthStrom"
  s.source = { :git => "https://github.com/DarthStrom/Moxie.git", :tag => "v#{s.version}" }
  s.source_files = "Sources/**/*.swift"
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '8.1'
end
