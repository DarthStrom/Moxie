# Installation

## Carthage

1. Create a `Cartfile.private` file if you don't already have one and add Moxie as a dependency, e.g.:
```ruby
# Cartfile.private

github "DarthStrom/Moxie"
```

2. Run `carthage update`.
3. Drag Moxie from your `Carthage/Build/[platform]/` directory into your test target's "Link Binary With Libraries" build phase.
4. Create a new "Copy Files" build phase for your test target.
5. Set the "Destination" to "Frameworks" and add the Moxie framework.

For more information on how to use Carthage, see the [Carthage documentation](https://github.com/Carthage/Carthage/blob/master/README.md).

## Cocoapods

1. Make sure you are using Cocoapods version 0.36.0 or newer for Swift support.
2. Create a `Podfile` file if you don't already have one and add Moxie as a testing dependency, e.g.:
```ruby
# Podfile

use_frameworks!

target 'CoolProjUnitTests' do
    pod 'Moxie'
end
```
3. Install your new dependency with `pod install`.
