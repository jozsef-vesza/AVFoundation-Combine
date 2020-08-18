![Combine wrappers for AVPlayer](images/header.png)

# AVFoundation-Combine
Combine extensions for AVFoundation

The purpose of this project is to add Combine wrappers around AVFoundation (specifically `AVPlayer` and `AVPlayerItem`) APIs. For a full technical rundown and detailed explanation please visit https://jozsef-vesza.dev/

## Publishers
All publishers are designed to be lazy: they only start observing properties when subscribed to.

## AVPlayer

### `playheadProgressPublisher()`
Emits values when the player's playhead updates. Under the hoood it uses `addPeriodicTimeObserver(forInterval:queue:using:)`. (see https://developer.apple.com/documentation/avfoundation/avplayer/1385829-addperiodictimeobserver)

```swift
player.playheadProgressPublisher()
    .sink { (time) in
        print("received playhead progress: \(time)")
    }
    .store(in: &subscriptions)
```

### `currentItemPublisher()`
Emits values when `currentItem` is updated. (see https://developer.apple.com/documentation/avfoundation/avplayer/1387569-currentitem)

```swift
player.currentItemPublisher()
    .compactMap { $0 }
    .sink { item in
        player.play()
    }
    .store(in: &subscriptions)
```

### `ratePublisher()`
Emits values when `rate` is updated. (see https://developer.apple.com/documentation/avfoundation/avplayer/1388846-rate)
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

## AVPlayerItem

### `statusPublisher()`
Emits values when `status` is updated. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1389493-status)

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

### `durationPublisher()`

Emits values when  `duration` is updated. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1389386-duration)

```swift
item.durationPublisher()
    .sink { duration in
        print("received duration: \(duration)")
    }
    .store(in: &subscriptions)
```

### `isPlaybackLikelyToKeepUpPublisher()`

Emits values when `isPlaybackLikelyToKeepUp` is updated. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1390348-isplaybacklikelytokeepup)

```swift
item.isPlaybackLikelyToKeepUpPublisher()
    .sink { isPlaybackLikelyToKeep in
        print("isPlaybackLikelyToKeep: \(isPlaybackLikelyToKeep)")
    }
    .store(in: &subscriptions)
```

### `isPlaybackBufferEmptyPublisher()`

Emits values when `isPlaybackBufferEmpty` is updated. (see https://developer.apple.com/documentation/avfoundation/avplayeritem/1386960-isplaybackbufferempty)

```swift
 item.isPlaybackBufferEmptyPublisher()  
    .sink { isPlaybackBufferEmpty in
        print("isPlaybackBufferEmpty: \(isPlaybackBufferEmpty)")
    }
    .store(in: &subscriptions)
```

### `didPlayToEndTimePublisher()`

Emits values when `NotificationCenter` fires `.AVPlayerItemDidPlayToEndTime`. (see https://developer.apple.com/documentation/foundation/nsnotification/name/1388007-avplayeritemfailedtoplaytoendtim)

```swift
item.didPlayToEndTimePublisher()
    .sink { notification in
        print("didPlayToEndTime: \(notification)")
    }
    .store(in: &subscriptions)
```