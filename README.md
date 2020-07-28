# AVFoundation-Combine [![Build Status](https://app.bitrise.io/app/eb242bc1129ada7c/status.svg?token=ScMXJ8iAaPN9Ir9-wOGixQ)](https://app.bitrise.io/app/eb242bc1129ada7c)
Combine extensions for AVFoundation

The purpose of this project is to add Combine wrappers around AVFoundation (specifically AVPlayer) APIs.

## Publishers
All publishers are designed to be lazy: they only start observing AVPlayer's properties when subscribed to.

### `playheadProgressPublisher`
`playheadProgressPublisher` will emit an event whenever the player's playhead updates. It may be used to update a custom progress indicator.
```swift
player.playheadProgressPublisher()
    .sink { (time) in
        print("received playhead progress: \(time)")
    }
    .store(in: &subscriptions)
```

### `ratePublisher`
`AVPlayer.ratePublisher` will emit an event whenever the rate of the observed player changes. It can be useful to present custom UI when the player is paused, or fast-forwarding/rewinding. (see https://developer.apple.com/documentation/avfoundation/avplayer/1388846-rate)
```swift
player.ratePublisher()
    .sink { (rate) in
        print("rate changed:")
        switch rate {
        case 0:
            print(">> paused")
        case 1:
            print(">> playing")
        default:
            print(">> \(rate)")
        }
    }
    .store(in: &subscriptions)
```

### `AVPlayer.statusPublisher`
`AVPlayer.statusPublisher` will emit an event when the status of the player's `playerItem` changes. It can be useful to defer work until the item is ready to play. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1389493-status)

```swift
player.statusPublisher()
    .sink { status in
        print("received status:")
        switch status {
        case .unknown:
            print(">> unknown")
        case .readyToPlay:
            print(">> ready to play")
        case .failed:
            print(">> failed")
        @unknown default:
            print(">> other")
        }
    }
    .store(in: &subscriptions)
```

`AVPlayer.statusPublisher` is also available as `AVPlayerItem.statusPublisher()`.

### `isPlaybackLikelyToKeepUpPublisher`
`AVPlayer.isPlaybackLikelyToKeepUpPublisher` will emit an event when the value of `isPlaybackLikelyToKeepUpPublisher` in the player's `playerItem` changes. This property communicates a prediction of playability. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1390348-isplaybacklikelytokeepup)

```swift
player.isPlaybackLikelyToKeepUpPublisher()
    .sink {isPlaybackLikelyToKeepUp in
        print(">> isPlaybackLikelyToKeepUp \(isPlaybackLikelyToKeepUp) ")
    }
    .store(in: &subscriptions)
```

`AVPlayer.isPlaybackBufferEmptyPublisher` is also available as `AVPlayerItem.isPlaybackLikelyToKeepUpPublisher()`.

### `isPlaybackBufferEmptyPublisher`
`isPlaybackBufferEmptyPublisher` will emit an event when the value of `isPlaybackBufferEmptyPublisher` in the player's `playerItem` changes. This property is a Boolean value that indicates whether playback has consumed all buffered media and that playback will stall or end. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1386960-isplaybackbufferempty)

```swift
player?.isPlaybackBufferEmptyPublisher()
    .sink {isPlaybackBufferEmpty in
        print(">> isPlaybackBufferEmpty \(isPlaybackBufferEmpty) ")
    }
    .store(in: &subscriptions)
```

`AVPlayer.isPlaybackBufferEmptyPublisher()` is also available as `AVPlayerItem.isPlaybackBufferEmptyPublisher()`.
