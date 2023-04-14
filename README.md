![cover](https://raw.githubusercontent.com/AlbertoLourenco/FloatingController/master/github-assets/cover.png)

FloatingController you can make views float above another ones.

## How to use

Create an object from FloatingController and add your custom UIView with size.

```swift
let customView = UIView()
customView.backgroundColor = .yellow

let floating = FloatingController()
floating.config(view: customView,
                size: CGSize(width: 220, height: 90))
```

Or, just to test you can call the funcion config wihtou any params.

```swift
let floating = FloatingController()
floating.config()
```

## Requirements

```
- iOS 13+
- Xcode 13
- Swift 5
```

## This project uses:

```
- UIKit
- UIWindow
```

## In action

![cover](https://raw.githubusercontent.com/AlbertoLourenco/FloatingController/master/github-assets/preview-1.gif)
![cover](https://raw.githubusercontent.com/AlbertoLourenco/FloatingController/master/github-assets/preview-2.gif)
