# WeScan

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
- [ ] Batch scanning

## Example

## Requirements
- Swift 4.0
- iOS 10.0+
- Xcode 9.x


## Installation

### Cocoapods
### Carthage
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
    scanner.dismiss(animated: true, completion: nil)
}

func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    // Your ViewController is responsible for dismissing the ImageScannerController
    scanner.dismiss(animated: true, completion: nil)
}
```

3. Simply present the `ImageScannerController` instance on your `ViewController`

```swift
// Somewhere on your ViewController
let scannerVC = ImageScannerController()
scannerVC.imageScannerDelegate = self
self.present(scannerVC, animated: true, completion: nil)
```
## Communication

- If you **found a bug**, open an [issue](https://github.com/WeTransfer/WeScan/issues).
- If you **have a feature request**, open an [issue](https://github.com/WeTransfer/WeScan/issues).
- If you **want to contribute**, submit a [pull request](https://github.com/WeTransfer/WeScan/pulls).

## License

**WeScan** is available under the MIT license. See the [LICENSE](https://github.com/WeTransfer/WeScan/blob/develop/LICENSE) file for more info.
