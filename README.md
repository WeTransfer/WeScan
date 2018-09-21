# WeScan

<p align="center">
    <img width="900px" src="Assets/WeScan-Banner.jpg">
</p>

<p align="center">
<img src="https://travis-ci.com/WeTransfer/WeScan.svg?token=Ur5V2zzKmBJLmMYHKJTF&branch=master"/>
<img src="https://img.shields.io/cocoapods/v/WeScan.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/l/WeScan.svg?style=flat"/>
<img src="https://img.shields.io/cocoapods/p/WeScan.svg?style=flat"/>
<img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/>
<img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=flat"/>
</p>

**WeScan** makes it easy to add scanning functionalities to your iOS app! 
It's modelled after `UIImagePickerController`, which makes it a breeze to use.

- [Features](#features)
- [Example](#example)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Communication](#communication)
- [License](#license)

## Features

- [x] Live scanning of documents
- [x] Edit detected rectangle
- [x] Fast
- [x] Lightweight dependency
- [ ] Batch scanning

## Example

<p align="center">
    <img src="Assets/WeScan.gif">
</p>

## Requirements

- Swift 4.0
- iOS 10.0+
- Xcode 9.x


## Installation

### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

To integrate **WeScan** into your Xcode project using CocoaPods, specify it in your `Podfile`:

```rubygi
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'WeScan', '>= 0.9'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate **WeScan** into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "WeTransfer/WeScan" >= 0.9
```

Run `carthage update` to build the framework and drag the built `WeScan.framework` into your Xcode project.

### Manually

Just download the project, and drag and drop the "WeScan" folder in your project.

## Usage

1. Make sure that your ViewController conforms to the `ImageScannerControllerDelegate` protocol
```swift
class YourViewController: UIViewController, ImageScannerControllerDelegate {

```

2. Implement the delegate functions
```swift
// Somewhere on your ViewController that conforms to ImageScannerControllerDelegate
func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    print(error)
}

func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
    // Your ViewController is responsible for dismissing the ImageScannerController
    scanner.dismiss(animated: true)
}

func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    // Your ViewController is responsible for dismissing the ImageScannerController
    scanner.dismiss(animated: true)
}
```

3. Simply present the `ImageScannerController` instance on your `ViewController`

```swift
// Somewhere on your ViewController
let scannerVC = ImageScannerController()
scannerVC.imageScannerDelegate = self
self.present(scannerVC, animated: true)
```
## Communication

- If you **found a bug**, open an [issue](https://github.com/WeTransfer/WeScan/issues).
- If you **have a feature request**, open an [issue](https://github.com/WeTransfer/WeScan/issues).
- If you **want to contribute**, submit a [pull request](https://github.com/WeTransfer/WeScan/pulls).

## License

**WeScan** is available under the MIT license. See the [LICENSE](https://github.com/WeTransfer/WeScan/blob/develop/LICENSE) file for more info.
