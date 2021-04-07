![Combine wrappers for AVPlayer](images/header.png)

# AVFoundationCombine
Combine extensions for AVFoundation

The purpose of this project is to add Combine wrappers around AVFoundation (specifically `AVPlayer` and `AVPlayerItem`) APIs. For a full technical rundown and detailed explanation please visit https://jozsef-vesza.dev/tags/combine/

You can also check out our talk on the topic:

[![Custom Publishers](https://img.youtube.com/vi/YcVe9L7fEJ0/0.jpg)](https://www.youtube.com/watch?v=YcVe9L7fEJ0)

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
