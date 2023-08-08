# VideoPlayerContainer

VideoPlayerContainer is a video player component for SwiftUI. Compared with the system built-in one [VideoPlayer](https://developer.apple.com/documentation/avkit/videoplayer), the VideoPlayerContainer provides much more flexible and extendable features that are able to cover most of the common scenarios that you can see on the app such as Tik Tok or Youtube.

![Platform](https://img.shields.io/badge/platform-iOS|macOS|visionOS-orange.svg)
![Version](https://img.shields.io/badge/version-16.0|13.0|1.0-green.svg)
![Version](https://img.shields.io/badge/deps-CocoaPods|SwiftPM-purple.svg)

## Showcase

<img src='https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/57a33161-0f59-4106-82f0-a81085c4e90e'><br/>
<img src='https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/07ace6fd-8fec-4761-8ed7-793bb588bb48'><br/>
<table>
    <tr>
        <img width="50%" src='https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/b85380ff-167a-42ba-bcb5-bf563dc90e87'>
        <img width="50%" src='https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/4df22d15-9d1b-4fcd-b381-01d05e223552'>
    </tr>
</table>
<img src='https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/40740310-1694-45f3-ac76-ad94a12019a1'><br/>
<img src='https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/e567ac32-f03b-4d68-9ecd-fc808c4cae63'><br/>
<img src='https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/c778bf0f-51bd-4153-bfa3-2030edc6bb82'><br/>

## Translation

* [简体中文](README-CN.md)

## Example

After cloning the repo and opening up the Xcode project, you can see multiple schemes as examples. Run it respectively to feel what abilities this framework can offer and how easy to use this framework to meet your demands.

* [Youtube-Example](Youtube-Example)
* [Bilibili-Example](Bilibili-Example)
* [TikTok-Example](TikTok-Example)
* [SystemVideoPlayer-Example](SystemVideoPlayer-Example)
* [VideoNavigation-Example](VideoNavigation-Example)
* [QuickTime-Example](QuickTime-Example)
* [VisionPro-Example](VisionPro-Example)

## Installation

VideoPlayerContainer supports multiple methods for installing the library in a project.

#### Installation with CocoaPods

To integrate VideoPlayerContainer into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
pod 'VideoPlayerContainer', :git => 'https://github.com/shayanbo/VideoPlayerContainer.git'
```

#### Installation with Swift Package Manager

Once you have your Swift package set up, adding VideoPlayerContainer as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/shayanbo/VideoPlayerContainer.git", .upToNextMajor(from: "1.0.0"))
]
```

## Core Concept

### Context

Context is the core class and is fully accessible from all of `Widget`s in the `VideoPlayerContainer`, it holds a service locator which we can use to fetch other `Service`s to borrow expertise from other `Widget`s. Adapters can access other `Service` instance by `context[Service.type]`. `Context` cache at a maximum of one `Service` instance for each `Service Type`. Besides, the built-in `Service` can be accessible by handy way such as `context.render`, `context.control` and so on.

### TestContext

`TestContext` is a specialized context for tests. when you author unit tests. you should create a `TestContext` instead of `Context` as the constructor parameter of `Service`. This kind of `Context` requires that you have register with `Service` factory method before fetching it from the `Context` instance. In this way, you can make the dependencies of `Service` behave predictably. And you can check the [Test](Test)'s Tests file as an example of `TestContext`.


### Widget

`Widget` is literally a SwiftUI View that's inside the `VideoPlayerContainer` which means it can access the `Context` and in most cases, it has a specific `Service` to handle all of its logic code and to communicate with other `Service`s. Generally, we use `WithService` as the root view of the `Widget` to access `Service` instance in `Widget`. This way, not only can we access `Service`'s APIs, but also the `Widget` updates upon the `State`s of `Service` changes.

### PlayerWidget

`PlayerWidget` is the container which holding all of built-in `Overlay`s and also the customized `Widget`s. It's the core View of `VideoPlayerContainer`.

### Service

`Service` represents two roles, one is the ViewModel in MVVM architecture, ViewModel handles all of the Output and Input for View. Another role is responsible for communicating with other `Service`s. We encourage people to write `Service` and `Widget` in one source file. This way, we can use `fileprivate`, and `private` to distinguish which APIs are used only for its `Widget` and which APIs are open to other `Service`s.

Actually, there're two kinds of `Service`: **Widget Service**, **Non-Widget Service**. **Widget Service** is the `Service` used by a specific `Widget` while **Non-Widget Service** is the `Service` used by other `Service`s.

### Overlay

`Overlay` is the sub-container inside the `VideoPlayerContainer` layer by layer and it's the place where widgets sit. We have 5 built-in overlays, from bottom to top, these are `render`, `feature`, `plugin`, `control`, and `toast`. In addition, we allow adopters to insert their own `Overlay`s.

![image](https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/9570d129-d8c4-4ebb-ac89-b8423a10cbf1)

#### Render Overlay

`Render overlay` is sitting at the far bottom of the container. It provides playback service and gesture services. Adapters can access `AVPlayer` and `AVPlayerLayer` instance. Besides, there's one overlay called `GestureOverlay` embbed in the `Render Overlay`. It provides the control over gestures. For example, `PlaybackWidget` in [VisionPro-Example](VisionPro-Example) support double-tap to pause and play by using `GestureService`, and `SeekbarWidget` support dragging horizontally to control the progress by using `GestureService`.

#### Feature Overlay

`Feature overlay` is used to slide in and out a panel from 4 directions (`left`, `right`, `top`, `bottom`). We provide two styles as well: `cover` or `squeeze`. `cover` literally display panel without having any affect on other `Overlay`s like [QuickTime-Example](QuickTime-Example)'s `PlaylistWidget`, while `squeeze` display panels with squeezing `Overlay`s to other side. [Youtube-Example](Youtube-Example)'s `CommentWidget`.

#### Plugin Overlay

`Plugin Overlay` is a sub-container without many constraints on it. When you want to show up a widget that's not suitable for other overlays and you don't want to insert your own custom overlay, that's the right place for you, like a thumbnail preview widget for the seek bar on dragging ([QuickTime-Example](QuickTime-Example)'s `SeekbarWidget` and `PreviewWidget` ) or a simple widget that's visible only in a short time after being triggered.

#### Control Overlay

`Control overlay` is the most sophisticated overlay and the place where most work will be done. The `Control Overlay` is divided into 5 parts: `left`, `right`, `top`, `bottom`, and `center`. Before going on, please allow me introduce a concept called `Status`: 

We predefined 3 statuses describing the environment of `PlayerWidget`. These are `halfscreen`, `fullscreen`, and `portrait`. The status changes are 100% decided by you. But generally, `halfscreen` describes the status of the portrait device that video's width is greater than it's height. `fullscreen` describes the landscape device that `PlayerWidget` fill up the whole screen, and `portrait` describes the status of the portrait device that the video's height is greater than the width.

For these 5 parts, you can configure them for different statuses which is quite common. For example, in `halfscreen` status, the screen is small and we can't attach many widgets to it but in fullscreen status. The video player container makes up the whole screen. We can attach many widgets to it to provide more and more functions.

For these parts, for these statuses, you can customize their shadow, transition, and layout. and other services can fetch the `ControlService` by `context.control` to call present or dismiss programmatically depending on the `DisplayStyle` configured.

![image](https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/421a5401-5615-435b-8fed-f6ef4d8c860c)

#### Toast Overlay

`Toast Overlay` is a relatively simple `Overlay` that you can use to pop up view on the left side which will be disappeared after a few seconds configured. It supports a few customization like customizing the Toast Widget.

## Usage: Add VideoPlayer

Let's say, we are going to author a player view in a video scene, here. We need to import `VideoPlayerContainer`, and create a `Context` for the player view or the whole video scene.

```swift

import VideoPlayerContainer

struct ContentView: View {
    
    @StateObject var context = Context()
    
    var body: some View {
    }
}

```

Now, you need to create the `PlayerWidget` to make it visible on the scene. It's the main container holding all of `Overlays` and `Widgets`. It requires a context instance to initialize it.

```swift

var body: some View {
    PlayerWidget(context)
}

```

The `PlayerWidget` is now attached to the scene. But you can't see it because we never do any configuration work and also don't pass the video resource item to play. Let's do some more work (specify the frame and play a video).

```swift

var body: some View {
    PlayerWidget(context)
        .frame(height: 300)
        .onAppear {

            /// play video
            let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
            context.render.player.replaceCurrentItem(with: item)
            context.render.player.play()
        }
}

```

Run it, and the video will be playing. Now, as you can see in other apps. We want to attach some widgets to it, like a button in the center to play or pause the video.

## Usage: Write Widgets

As I said above, we need to write a playback control button and attach it to the center of the `PlayerWidget`. First of all, we need to create a SwiftUI source file named `PlaybackWidget` and author some basic UI code.

```swift

struct PlaybackButtonWidget: View {
    var body: some View {
    	Image(systemName: "play.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .disabled(!service.clickable)
            .onTapGesture {
                /// tap handler
            }
    }
}

```

This is a view showing a Play icon. Now, we need to attach it to the `PlayerWidget`. Here, we add it to the `Control Overlay`.

```swift

var body: some View {
    PlayerWidget(context)
        .frame(height: 300)
        .onAppear {

            /// add widgets to the center for halfscreen status
            context.control.configure(.halfScreen(center)) {[
                PlaybackButtonWidget()
            ]}

            /// play video
            let item = AVPlayerItem(url: Bundle.main.url(forResource: "demo", withExtension: "mp4")!)
            context.render.player.replaceCurrentItem(with: item)
            context.render.player.play()
        }
}

```

Now, you can see an play icon in the center. Based on default `DisplayStyle` which is `auto`, you can tap the blank area to hide or show the `Control Overlay`. However, when you tap the play icon, you will find nothing happens since we don't populate the logic code to make the `Widget` work as expected (play and pause). How?

When we created the `PlayerWidget` and passed in the `Context` instance, the `Context` instance will be put in the environment. Thus, all of the `Widget`s inside the `PlayerWidget` will have access to the `Context`. Instead of accessing `Context` directly inside the `Widget`, we prefer using `WithService` as the root View of the `Widget` to access the `Service` instance. It offers an abilities that get the `Widget` update when the `State` of `Service` changes.

```swift

fileprivate class PlaybackService: Service {
    
    private var rateObservation: NSKeyValueObservation?
    
    private var statusObservation: NSKeyValueObservation?
    
    @ViewState var playOrPaused = false
    
    @ViewState var clickable = false
    
    required init(_ context: Context) {
        super.init(context)
        
        let service = context[RenderService.self]
        rateObservation = service.player.observe(\.rate, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.playOrPaused = player.rate > 0
        }
        
        statusObservation = service.player.observe(\.status, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.clickable = player.status == .readyToPlay
        }
    }
    
    func didClick() {
        if context.render.player.rate == 0 {
            context.render.player.play()
        } else {
            context.render.player.pause()
        }
    }
}

struct PlaybackWidget: View {
    var body: some View {
        WithService(PlaybackService.self) { service in
            Image(systemName: service.playOrPaused ? "pause.fill" : "play.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .disabled(!service.clickable)
                .onTapGesture {
                    service.didClick()
                }
        }
    }
}

```

As you can see above, it's a completed `Widget`. 

* We use `fileprivate` modifier to mark APIs that's only available for its belonging `Widget`.
* We use `@ViewState` to mark the variable that's able to trigger the `SwiftUI` update mechanism (like @Published, @State).
* We use `WithService` as the `Widget`'s root View to make sure any `@ViewState` variable changes will make the whole `Widget` involved in the update mechanism.
* We use `@ViewState` variable to condition which image to use in the Widget. (ViewModel's Output).
* We call `Service` method to complete the `Widget`'s work (ViewModel's Input).

## Access Modifiers in Service

We encourage adopters to author `Widget` and its `Service` in the same source file. In this way, we can make full use of access modifiers on `Service`.

1. If you are creating a **Widget Service** that is only used by its `Widget`, `fileprivate` is better to modify the `Service` class. Since it's only able to be accessed by the `Widget` in the same source file. Also, keep using `private` to modify those properties and methods that are used only inside the `Service`.
2. If you are creating a **Widget Service** that offers some API for other `Service`s, `internal` or `public` is better to modify the `Service` class. Since other `Service`s have to access your `Service` Type in the compilation time. Also, keep using `private` to modify those properties and methods that are used only inside the `Service` and using `fileprivate` to modify those properties and methods that are used only by its `Widget`.
3. If you are creating a **Non-Widget Service** that offers some API for other `Service`s, `internal` or `public` is better to modify the `Service` class. Since other `Service`s have to access your `Service` Type in the compilation time. Also, keep using `private` to modify those properties and methods that are used only inside the `Service`.

## Idea / Bug / Improvement

Feel free to report issues and let's improve it together 😀.
 
## License

VideoPlayerContainer is released under the MIT license. See [LICENSE](LICENSE) for details.
