# Installation

## Installing MockingBird

### Carthage

1. Create a `Cartfile.private` file if you don't already have one and add the line `github "DarthStrom/MockingBird"`
1. Run `carthage update`.  This will fetch the source code and put it in `Carthage/Checkouts` and then build it and put it in `Carthage/Build`.
1. On your test target's "Build Phases" settings tab, in the "Link Binary With Libraries" section, drag and drop the `MockingBird.framework` from the `Carthage/Build/[platform]` folder on disk.
1. On your test target's "Build Phases" settings tab, create a new build phase of type "Copy Files", then set the Destination to Frameworks and add the MockingBird framework.

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
