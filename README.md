# VideoPlayerContainer
-

VideoPlayerContainer is a SwiftUI component as a video player. Compared with the system built-in one [VideoPlayer](https://developer.apple.com/documentation/avkit/videoplayer). the VideoPlayerContainer provides much more flexible and extendable abilities that's able to cover most of common scenes that you can see on the apps such as Tiktok or Youtube.

## Showcase

<table>
	<tr>
		<td> YouTube </td>
		<td> <img src='Resources/Youtube_Halfscreen.png'> </td>
		<td> <img src='Resources/Youtube_Fullscreen.png'> </td>
		<td> <img src='Resources/Youtube_Fullscreen_Squeeze.png'> </td>
	</tr>
</table>

<table>
	<tr>
		<td> Tiktok </th>
		<td> <img src='Resources/Tiktok_Squeeze.png'> </td>
		<td> <img src='Resources/Tiktok_Portrait.png'> </td>
	</tr>
</table>

<table>
	<tr>
		<td> Bilibili </th>
		<td> <img src='Resources/Bilibili_Halfscreen.png'> </td>
		<td> <img src='Resources/Bilibili_Fullscreen.png'> </td>
	</tr>
</table>

## Installation

VideoPlayerContainer supports multiple methods for installing the library in a project.

#### Installation with CocoaPods

To integrate VideoPlayerContainer into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
pod 'VideoPlayerContainer', :git => 'https://github.com/MickeyHub/VideoPlayerContainer.git'
```

#### Installation with Swift Package Manager

Once you have your Swift package set up, adding VideoPlayerContainer as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/MickeyHub/VideoPlayerContainer.git", .upToNextMajor(from: "1.0.0"))
]
```

## Requirements

Since I use some of new features like custom Layout, the current version is required a minimum `iOS` version of `16.0`, and `macOS` version of `13.0`. but I'm considering of lowering the minimum version support to `iOS 14.0` and `macOS 12.4`

## Concept Before Usage