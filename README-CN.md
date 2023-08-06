# VideoPlayerContainer

VideoPlayerContainer 是一个基于SwiftUI的视频播放组件. 相比于系统内置的[VideoPlayer](https://developer.apple.com/documentation/avkit/videoplayer), VideoPlayerContainer 提供了更多灵活的, 可扩展的特性. 基本可以覆盖市面上看到的常见视频app的使用. 比如Tik Tok 或者 Youtube.

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


## Example

克隆仓库之后, 打开Xcode工程, 你可以看到有很多示例项目. 你可以分别运行他们来查看这个框架提供了哪些能力, 以及它是否可以很容易得实现你的需求.

* [Youtube-Example](Youtube-Example)
* [Bilibili-Example](Bilibili-Example)
* [TikTok-Example](TikTok-Example)
* [SystemVideoPlayer-Example](SystemVideoPlayer-Example)
* [VideoNavigation-Example](VideoNavigation-Example)
* [QuickTime-Example](QuickTime-Example)
* [VisionPro-Example](VisionPro-Example)

## 安装

VideoPlayerContainer 支持多种方法的集成方式

#### 使用CocoaPods

使用CocoaPods 集成 VideoPlayerContainer, 你需要将下面代码放到你工程中的 `Podfile`:

```
pod 'VideoPlayerContainer', :git => 'https://github.com/shayanbo/VideoPlayerContainer.git'
```

#### 使用SwiftPM

在工程的 `Package.swift` 中添加如下依赖:

```
dependencies: [
    .package(url: "https://github.com/shayanbo/VideoPlayerContainer.git", .upToNextMajor(from: "1.0.0"))
]
```

## 核心概念

### Context (上下文)

`Context` 是一个核心类, 他可以被 `VideoPlayerContainer` 内所有的 `Widget` 访问到, `Context` 内部持有一个服务定位器(service locator), 提供 `Service` 之间访问的能力. 可以通过context[Service.Type]获取其他 `Service` 实例. `Context` 保证缓存的 `Service` 实例最多只有一个. 除此之外. 内置的 `Service` 提供了扩展API可以方便的获取, 比如 `context.render`, `context.control` 等.

### Widget (控件)

`Widget` 本身就是 `VideoPlayerContainer` 中一个 `SwiftUI` 的 `View`, 他可以访问到 `Context` 对象, 绝大多数的情况下, 会为它编写一个专门的 `Service` 对象来处于逻辑和负责Service间通讯的工作. 通常我们会在 `Widget` 中使用 `WithService` 作为根视图来访问相应的 `Service`. 这样既能使用 `Service` 提供的方法, 还会在 `Service` 的State变化的时候, 自动刷新当前 `Widget`.

### PlayerWidget (播放容器控件)

`PlayerWidget` 是 `VideoPlayerContainer` 提供的播放容器, 内部持有了所有了内置 `Overlay`, 也持有了所有自定义的 `Widget`. 是使用该库需要构建的核心视图.

### Service (服务)

`Service` 代表了两个角色. 其一: 它作为MVVM架构的ViewModel, ViewModel 处理它所属的 `Widget` 的所有的 Output和Input. 其二: 它负责和其他 `Service` 之间的通讯. 我们鼓励大家在同一个源文件中编写 `Service` 和 `Widget`. 如此一来, 我们就可以使用 `fileprivate` 和 `private` 来区分哪些API是所属Widget专享的, 哪些API是提供给其他 `Service` 使用的.

事实上, 存在两种 `Service`: **Widget Service**, **Non-Widget Service**. **Widget Service** 指的是那些被特定 `Widget` 使用的 `Service` while **Non-Widget Service** 指的是那些专门给其他 `Service`s 使用的 `Service`.

### Overlay (层)

`Overlay` 指的是 `PlayerWidget` 内叠加布局的子容器. 每个子容器都有专门的 `Service` 来对外提供能力. 我们一共内置了5个 `Overlay`, 从下往上依次是: render, feature, plugin, control, and toast. 除此之外, 我们也允许使用者插入自定义的 `Overlay`.

![image](https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/9570d129-d8c4-4ebb-ac89-b8423a10cbf1)

#### Render Overlay (播控渲染层)

`Render Overlay` 位于 `PlayerWidget` 的最底层. 它对外提供了播控能力. 可以访问到 `AVPlayer` 和 `AVPlayerLayer`. 除此之外. 该层还内嵌了一个 `Gesture Overlay`. 对外提供手势控制的能力. 比如 [VisionPro-Example](VisionPro-Example) 中 `PlaybackWidget` 通过 `GestureService` 实现了双击暂停和播放, 以及 `SeekBarWidget` 使用 `GestureService` 实现水平左右滑动来快进和后退.

#### Feature Overlay (面板层)

`Feature overlay` 用于展示面板. 这个面板可以从上下左右四个方向出现. 而且我们提供了两种样式, 一种是覆盖式的展示, 不影响其他Overlay, 比如 [QuickTime-Example](QuickTime-Example) 中的播单 `PlaylistWidget`. 另一种就是挤压式的展示, 会把所有Overlay挤压到另一侧, 比如 [Youtube-Example](Youtube-Example) `CommentWidget` 中.

#### Plugin Overlay (插件层)

`Plugin Overlay` 是一个没有太多规则约束的控件容器. 当你想要展示一个控件, 这个控件不太适合其他层而且你也不想插入自定义层的时候, 那这个插件层可能就比较合适, 比如视频进度拖拽的预览控件 ([QuickTime-Example](QuickTime-Example)的 `SeekBarWidget` 和 `PreviewWidget` )或者是一个某个逻辑触发之后会展示一小会的控件.

#### Control Overlay (控制层)

`Control Overlay` 是最复杂的一层, 也是大部分 `Widget` 所在的一层. `Control Overlay` 被划分成5个区域: `左`, `右`, `上`, `下`, and `中`. 再继续讲述之前, 我们需要先介绍一个概念叫 `Status`: 

我们预定义了3个 `Status` 分别是 `halfscreen`, `fullscreen` 和 `portrait`. `Status` 表达了当前 `PlayerWidget` 所处的一种状态. 这个状态的变化百分百由使用者控制. 但是通常来讲, `halfscreen` 描述的是在竖屏设备下, 视频宽度大于高度的一种状态. 这种是比较常见的, 比如在Youtube的视频播放页等. `fullscreen` 描述的是一种在横屏设备下, `PlayerWidget` 占满整个屏幕的状态, 比如Youtube的全屏模式. `portrait` 描述的是在竖屏设备下, 视频的高度大于宽度的一种状态, 比如TikTok的视频.

对于这5个区域, 以及每个区域不同的 `Status`, 我们都可以分别设置需要展示的 `Widget`s 以及布局. 举个例子, 在 `halfscreen` 状态, `PlayerWidget` 的显示区域比较小, 我们没法防止太多的 `Widget`, 但是在 `fullscreen` 状态. `PlayerWidget` 占满整个屏幕, 我们可以放置更多的 `Widget` 来提供更多的常驻在屏幕上的功能.

除此之外, 对于这些不同的区域, 以及每个区域的不同状态, 你还可以自定义他们的阴影, 背景, 过渡动画 以及布局等. 其他 `Service` 也可以通过 `context.control` 来触发它的展示或者隐藏, 当然这个行为依赖于开发者自己设置的 `DisplayStyle`.

![image](https://github.com/shayanbo/VideoPlayerContainer/assets/5426838/421a5401-5615-435b-8fed-f6ef4d8c860c)

#### Toast Overlay (提示层)

`Toast Overlay` 是一个相对简单的 `Overlay`, 正如它的名字一样, 他提供了一些Toast提示的服务. 支持连续多个Toast弹出, 旧的Toast会被顶到上面. 直接N秒后自动消失. 目前这个Toast出现和消失的Transition是不对外暴露的, 限定于从左侧入, 然后淡出. 其他的都是可配置的, 比如: 展示时长, 自定义Toast等.

## 使用: 添加 VideoPlayer

比如说, 我们正在视频播放页里面添加一个视频播放组件. 在这, 我们要先导入 `VideoPlayerContainer`, 然后为该视频播放页创建 `Context` 实例.

```swift
import VideoPlayerContainer

struct ContentView: View {
    
    @StateObject var context = Context()
    
    var body: some View {
    }
}
```

现在, 你需要创建一个 `PlayerWidget` 放置到页面上. `PlayerWidget` 是本库的主要控件容器. 内部包含所有的 `Overlay`, 也会包含我们所有自定义的控件. `PlayerWidget`需要传入一个 `Context` 实例进行初始化.

```swift
var body: some View {
    PlayerWidget(context)
}
```

`PlayerWidget` 现在被添加到页面上了. 但是你看不到它, 因为我们没有做任何配置, 也没有传入视频资源让它播放. 那么, 让我们进一步完成它吧 (设置frame, 播放视频).

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

运行, 我们能够看到视频开始播放了. 正如你在其他app上看到的那样, 我们希望可以在上面添加一下控件, 比如: 一个播控按钮.

## 使用: 编写 Widgets

就像上面说的那样, 我们需要编写一个播控按钮, 然后把它放到 `PlayerWidget` 的中央. 首先, 我们需要创建一个 `SwiftUI` 源文件叫做 `PlaybackButtonWidget` 然后编写基础的UI.

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

这样我们就完成了一个播控 `Widget` 的UI部分, 他展示了一个播放图标. 现在我们要把它添加到 `PlayerWidget` 内. 这里我们选择添加到 `PlayerWidget` 的 `Control层` .

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

现在, 你可以在 `PlayerWidget` 的中央看到这个图标. 基于 `Control` 层的默认 `DisplayStyle`, 你可以点击 `Control` 层的空白区域来让该层显示或者隐藏. 但是当你点击播放按钮的时候, 你会发现并没有事情发生. 因为我们还没有编写事件响应代码. 怎么办?

当我们创建一个 `PlayerWidget` 并且传入 `Context` 实例之后, 这个 `Context` 实例会被放入Environment. 因此, 所有在 `PlayerWidget` 的控件都能够访问到这个 `Context` 实例. 相较于在 `Widget` 内直接访问 `Context`, 我们更推荐使用 `WithService` 来访问自己的 `Service`, 并且该 `Service` 的State变动会自动更新该控件.

```swift
class PlaybackService: Service {
    
    private var rateObservation: NSKeyValueObservation?
    
    private var statusObservation: NSKeyValueObservation?
    
    @ViewState fileprivate var playOrPaused = false
    
    @ViewState fileprivate var clickable = false
    
    required init(_ context: Context) {
        super.init(context)
        
        rateObservation = context.render.player.observe(\.rate, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.playOrPaused = player.rate > 0
        }
        
        statusObservation = context.render.player.observe(\.status, options: [.old, .new, .initial]) { [weak self] player, change in
            self?.clickable = player.status == .readyToPlay
        }
    }
    
    fileprivate func didClick() {
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

上述就是一个完整的播控 `Widget`.

* 我们使用 `fileprivate` 修饰符来标记API是 `Widget` 专享的方法.
* 我们使用 `@ViewState` 来标记那些可以触发 `SwiftUI` 刷新机制的变量 (类似于 @Published, @State).
* 我们使用 `WithService` 作为 `Widget` 的根视图来确保任何 `@ViewState` 变量的变化都会触发整个 `Widget` 的UI刷新.
* 在 `Widget`中, 我们使用 `@ViewState` 变量来判断哪个图片需要被展示. (角色: ViewModel's Output).
* 我们调用 `Service` 的方法来完成 `Widget` 的工作 (角色: ViewModel's Input).

## Service中的访问修饰符的使用

我们鼓励使用者在同一个源文件中编写 `Widget` 和对应的 `Service`. 这样, 我们就可以在 `Service` 中充分利用访问修饰符.

1. 如果你正在编写一个只被 `Widget` 使用到的 **Widget Service**, 我们推荐使用 `fileprivate` 来修饰这个 `Service` 的class. 因为它只被同一个源文件中的 `Widget` 使用. 当然, 对于那些只在 `Service` 内部使用的变量和方法, 还是需要使用 `private` 来修饰.
2. 如果你正在编写一个需要提供给其他 `Service`s 调用的 **Widget Service**, 我们推荐使用 `internal` 或者 `public` 来修饰这个 `Service` 的class. 因为其他的 `Service`s 需要在编译期间通过 `Context` 访问到你的 `Service`. 当然, 对于那些只在 `Service` 内部使用的变量和方法, 还是需要使用 `private` 来修饰. 对于那些只在所属的 `Widget` 内使用的变量和方法, 还是需要使用 `fileprivate` 来修饰.
3. 如果你正在编写一个 **Non-Widget Service**. 我们推荐使用 `internal` 或者 `public` 来修饰这个 `Service` 的class. 因为其他的 `Service`s 需要在编译期间通过 `Context` 访问到你的 `Service`. 当然, 对于那些只在 `Service` 内部使用的变量和方法, 还是需要使用 `private` 来修饰.

## 想法 / 缺陷 / 改进

任何问题都可以在Issue板块提出, 我们会及时沟通并且共同改进😀.

## 开源协议

VideoPlayerContainer 是基于 MIT 协议发布的开源框架. 更多细节在 [LICENSE](LICENSE).
