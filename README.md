![Combine wrappers for AVPlayer](images/header.png)
# AVFoundationCombine
Combine extensions for AVFoundation

[![Test](https://github.com/jozsef-vesza/AVFoundation-Combine/actions/workflows/test.yml/badge.svg)](https://github.com/jozsef-vesza/AVFoundation-Combine/actions/workflows/test.yml) [![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjozsef-vesza%2FAVFoundation-Combine%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/jozsef-vesza/AVFoundation-Combine) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fjozsef-vesza%2FAVFoundation-Combine%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/jozsef-vesza/AVFoundation-Combine)

This project aims at providing uniformity and reducing boilerplate by providing `Publisher` extensions for common tasks when working with the `AVFoundation` framework.

For a full technical rundown and detailed explanation on this motivation and useful technical details on implementing custom `Publisher`s, please visit https://jozsef-vesza.dev/tags/combine/

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
| **AVAsset** | |
|     `commonMetadataPublisher(key:)`      |    `commonMetadata`    |
|     `commonMetadataValuePublisher(key:)`      |    `commonMetadata`    |
|     `commonMetadataExtrasPublisher(key:)`      |    `commonMetadata`    |
|     `commonMetadataValuePublisher(key:as:)`      |    `commonMetadata`    |
|     `commonMetadataValuePublisher(stringValueKey:)`      |    `commonMetadata`    |
|     `commonMetadataArtworkPublisher()`      |    `commonMetadata`    |

## License

AVFoundationCombine is available under the MIT license. See the [LICENSE](https://github.com/jozsef-vesza/AVFoundation-Combine/blob/master/LICENSE) file for more info.
