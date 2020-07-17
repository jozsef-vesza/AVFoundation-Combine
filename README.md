# AVFoundation-Combine
Combine extensions for AVFoundation

The purpose of this project is to add Combine wrappers around AVFoundation (specifically AVPlayer) APIs.

## Publishers
All publishers are designed to be lazy: they only start observing AVPlayer's properties when subscribed to.

### `PlayheadProgressPublisher`
`PlayheadProgressPublisher` will emit an event whenever the player's playhead updates. It may be used to update a custom progress indicator.
```swift
player.playheadProgressPublisher()
    .sink { (time) in
        print("received playhead progress: \(time)")
    }
    .store(in: &subscriptions)
```

### `PlayerRatePublisher`
`PlayerRatePublisher` will emit an event whenever the rate of the observed player changes. It can be useful to present custom UI when the player is paused, or fast-forwarding/rewinding. (see https://developer.apple.com/documentation/avfoundation/avplayer/1388846-rate)
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

### `PlayerItemStatePublisher`
`PlayerItemStatePublisher` will emit an event when the status of the player's `playerItem` changes. It can be useful to defer work until the item is ready to play. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1389493-status)

```swift
player.statePublisher()
    .sink { state in
        print("received status:")
        switch state {
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

`PlayerItemStatePublisher` is also available as `AVPlayerItem.statePublisher()`.

### `PlayerItemIsPlaybackLikelyToKeepUpPublisher`
`PlayerItemIsPlaybackLikelyToKeepUpPublisher` will emit an event when the value of `isPlaybackLikelyToKeepUpPublisher` in the player's `playerItem` changes. This property communicates a prediction of playability. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1390348-isplaybacklikelytokeepup)

```swift
player.isPlaybackLikelyToKeepUpPublisher()
    .sink {isPlaybackLikelyToKeepUp in
        print(">> isPlaybackLikelyToKeepUp \(isPlaybackLikelyToKeepUp) ")
    }
    .store(in: &subscriptions)
```

`PlayerItemIsPlaybackLikelyToKeepUpPublisher` is also available as `AVPlayerItem.isPlaybackLikelyToKeepUpPublisher()`.