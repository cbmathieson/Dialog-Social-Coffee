# Neumorphic SwiftUI : Neumorphism Soft UI

Neumorphic is a SwiftUI utility to build Neumorphism Soft UI easily using custom view modifier and custom button style. It supports all shapes. 

Hi, I’m Costa. It is simple to create outer shadow in SwiftUI by writing two lines of code. However, we can’t easily create inner shadow in SwiftUI. That’s the reason why I build this tool to make it simple and reusable.

![Image of Neumorphic SwiftUI](https://user-images.githubusercontent.com/169746/77291563-7bfcda80-6d19-11ea-84ff-1ae527e425fa.png)


## Installation
Requirements
.iOS(.v13),.macOS(.v10_15)

#### Swift Package Manager 
1. In Xcode, open your project and navigate to File → Swift Packages → Add Package Dependency.
2. Paste the repository URL (https://github.com/costachung/neumorphic/) and click Next.
3. For Rules, select version.
4. Click Finish.

#### Swift Package
```swift
.package(url: "https://github.com/costachung/neumorphic/", .upToNextMajor(from: "1.2.0"))
```

## Usage
Import Neumorphic package to your view.

```swift
import Neumorphic
```

Simply use **.softOuterShadow** and **.softInnerShadow** methods to create outer shadow and inner shadow respectively.

#### Create Rounded Rectangle with Outer Shadow

![Neumorphic SwiftUI Outer Shadow](https://user-images.githubusercontent.com/169746/77294908-fcbed500-6d1f-11ea-9125-cab24891a03d.png)

```swift
RoundedRectangle(cornerRadius: 20).fill(Neumorphic.shared.mainColor()).softOuterShadow()
```

#### Create Rounded Rectangle with Inner Shadow

![Neumorphic SwiftUI Inner Shadow](https://user-images.githubusercontent.com/169746/77295134-57f0c780-6d20-11ea-8e40-88b7a15319aa.png)

```swift
RoundedRectangle(cornerRadius: 20).fill(Neumorphic.shared.mainColor()).softInnerShadow(RoundedRectangle(cornerRadius: 20))
```

#### Create Circles
![Neumorphic SwiftUI Circles](https://user-images.githubusercontent.com/169746/77296271-60e29880-6d22-11ea-942b-23d4e503f03e.png)

```swift
  HStack {
      Circle().fill(Neumorphic.shared.mainColor()).softOuterShadow()
      Circle().fill(Neumorphic.shared.mainColor()).softInnerShadow(Circle())
  }
```

#### Create Soft Button
![Neumorphic SwiftUI Button](https://user-images.githubusercontent.com/169746/77301621-f6822600-6d2a-11ea-9248-88a4fa6c9abc.png)
```swift
Button(action: {}) {
    Text("Soft Button").fontWeight(.bold)
}
.softButtonStyle(RoundedRectangle(cornerRadius: 20))
```

#### Create Soft Button with custom style
![Neumorphic SwiftUI Button](https://user-images.githubusercontent.com/169746/77302381-34337e80-6d2c-11ea-96d6-6409a7e14c92.png)
```swift
HStack {
    Button(action: {}) {
        Image(systemName: "heart.fill")
    }.softButtonStyle(Circle())

    Button(action: {}) {
        Image(systemName: "heart.fill")
    }.softButtonStyle(Circle(), mainColor: Color.red, textColor: Color.white, darkShadowColor: Color(rgb: 0x993333, alpha: 1), lightShadowColor:Color("redButtonLightShadow"))
}
```

## Customization 

#### softInnerShadow
You can change the color, spread of the shadow, and the shadow radius of the inner shadow.
```swift
softInnerShadow<S : Shape>(_ content: S, darkShadow: Color, lightShadow: Color, spread: CGFloat, radius: CGFloat)
```
#### softOuterShadow
You can change the color, offset of the shadow, and the shadow radius of the outer shadow.
```swift
softOuterShadow(darkShadow: Color, lightShadow: Color, offset: CGFloat, radius:CGFloat)
```

For example,
![Neumorphic SwiftUI Search bar](https://user-images.githubusercontent.com/169746/77886613-c8a56000-729b-11ea-87d8-3742146645e6.png)
```swift
            ZStack {
                RoundedRectangle(cornerRadius: 30).fill(mainColor)
                            .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: darkShadow, lightShadow: lightShadow, spread: 0.05, radius: 2)
                HStack{
                    Image(systemName: "magnifyingglass").foregroundColor(secondaryColor).font(Font.body.weight(.bold))
                    Text("Search ...").foregroundColor(secondaryColor).fontWeight(.bold)
                    Spacer()
                }.padding()
            }.frame(width: 300, height:50)
```

Example of using background method to add it under TextField:
```swift
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(secondaryColor).font(Font.body.weight(.bold))
                    TextField("Search ...", text: $name).foregroundColor(secondaryColor)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30).fill(mainColor)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: darkShadowColor, lightShadow: lightShadowColor, spread: 0.05, radius: 2)
                )
            }
            .padding()
```


Or, something like this:

![Neumorphic SwiftUI bar chart](https://user-images.githubusercontent.com/169746/77887392-1078b700-729d-11ea-911c-3fd94ba1b9e0.png)
```swift
ZStack(alignment: .bottom){
                RoundedRectangle(cornerRadius: 20).fill(mainColor)
                .softInnerShadow(RoundedRectangle(cornerRadius: 20), darkShadow: darkShadow, lightShadow: lightShadow, spread: 0.3, radius: 2)
                .frame(width: 30, height:150)
                
                RoundedRectangle(cornerRadius: 20).fill(barColor)
                    .frame(width: 30, height:100)
            }
```


## Example Project
Check out the __neumorphic-ios-example__ XCode project to see how to build neumorphic UI and buttons. If you use the default shadow colors of Neumorphic, you can also get dark mode support for free.

## Contacts
https://twitter.com/costachung

# License
Neumorphic Package is released under the MIT license. See the LICENSE file for more info.
