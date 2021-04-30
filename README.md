![Combine wrappers for AVPlayer](images/header.png)
# AVFoundationCombine
Combine extensions for AVFoundation

[![Test](https://github.com/jozsef-vesza/AVFoundation-Combine/actions/workflows/test.yml/badge.svg)](https://github.com/jozsef-vesza/AVFoundation-Combine/actions/workflows/test.yml) [![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

The purpose of this project is to add Combine wrappers around AVFoundation (specifically `AVPlayer` and `AVPlayerItem`) APIs. For a full technical rundown and detailed explanation please visit https://jozsef-vesza.dev/tags/combine/

You can also check out our talk on the topic:

[![Custom Publishers](https://img.youtube.com/vi/YcVe9L7fEJ0/0.jpg)](https://www.youtube.com/watch?v=YcVe9L7fEJ0)

## Installation

### Swift Package Manager

Once you have a Swift package set up, adding AVFoundationCombine as a dependency can be done by adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/jozsef-vesza/AVFoundation-Combine", .upToNextMajor(from: "0.0.0"))
]
```


## Publishers
All publishers are designed to be lazy: they only start observing properties when subscribed to.


| Publisher | Source |
|-----------|--------|
| **AVPlayer** | |
|     `playheadProgressPublisher(interval:)`      |    `addPeriodicTimeObserver(forInterval:queue:using:)`    |
|     `currentItemPublisher()`      |    `currenItem`    |
|     `ratePublisher()`      |    `rate`    |
| **AVPlayerItem** | |
|     `statusPublisher()`      |    `status`    |
|     `durationPublisher()`      |    `duration`    |
|     `isPlaybackLikelyToKeepUpPublisher()`      |    `isPlaybackLikelyToKeepUp`    |
|     `isPlaybackBufferEmptyPublisher()`      |    `isPlaybackBufferEmpty`    |
|     `didPlayToEndTimePublisher(_:)`      |    `.AVPlayerItemDidPlayToEndTime` Notification    |

## License

AVFoundationCombine is available under the MIT license. See the [LICENSE](https://github.com/jozsef-vesza/AVFoundation-Combine/blob/master/LICENSE) file for more info.
