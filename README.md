# iOS Photo Editor

## Features
- [x] Cropping 
- [x] Adding images -Stickers-
- [x] Adding Text with colors
- [x] Drawing with colors
- [x] Scaling and rotating objects 
- [x] Deleting objects 
- [x] Saving to photos and Sharing 
- [x] Cool animations 
- [x] Uses iOS Taptic Engine feedback 

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/M-Hamed/photo-editor.git", from: "1.0.0")
]
```

Or in Xcode:
1. Go to **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/M-Hamed/photo-editor.git`
3. Select the version you want to use

## Usage

### Photo Editor

Create and present the `PhotoEditorViewController`:

```swift
import iOSPhotoEditor

let photoEditor = PhotoEditorViewController()

//PhotoEditorDelegate
photoEditor.photoEditorDelegate = self

//The image to be edited 
photoEditor.image = image

//Stickers that the user will choose from to add on the image         
photoEditor.stickers.append(UIImage(named: "sticker" )!)

//Optional: To hide controls - array of enum control
photoEditor.hiddenControls = [.crop, .draw, .share]

//Optional: Colors for drawing and Text, If not set default values will be used
photoEditor.colors = [.red,.blue,.green]

//Present the View Controller
present(photoEditor, animated: true, completion: nil)
```
The `PhotoEditorDelegate` methods.

```swift
func doneEditing(image: UIImage) {
    // the edited image
}
    
func canceledEditing() {
    print("Canceled")
}

```

<img src="Assets/screenshot.PNG" width="350" height="600" />

# Live Demo appetize.io
[![Demo](Assets/appetize.png)](https://appetize.io/app/jtanmwtzbz1favhvhw5g24n7b0?device=iphone7plus&scale=50&orientation=portrait&osVersion=10.3)


# Demo Video 
[![Demo](https://img.youtube.com/vi/9VeIl9i30dI/0.jpg)](https://youtu.be/9VeIl9i30dI)

## Credits

Written by [Mohamed Hamed](https://github.com/M-Hamed).

Initially sponsored by [![Eventtus](http://assets.eventtus.com/logos/eventtus/standard.png)](http://eventtus.com)

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT).
