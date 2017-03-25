# Installation

## Installing MockingBird

### Cocoapods

1. Make sure you are using Cocoapods version 0.36.0 or newer for Swift support.
2. Create a `Podfile` file if you don't already have one and add MockingBird as a testing dependency, e.g.:
```ruby
# Podfile

use_frameworks!

def testing_pods
    pod 'MockingBird', :git => 'https://github.com/DarthStrom/MockingBird.git'
end

target 'CoolProjUnitTests' do
    testing_pods
end

target 'CoolProjUITests' do
    testing_pods
end
```
3. Install your new dependency with `pod install`
