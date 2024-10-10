import Foundation
import AVFoundation

public struct ZemPlayerMediaTrack {
    public var option: AVMediaSelectionOption
    public var group: AVMediaSelectionGroup
    public var name: String
    public var language: String
    
    public func select(for player: ZemPlayer) {
        player.currentItem?.select(option, in: group)
    }
}
