//
//  VerticalVideoCollectionViewCell.swift
//  bbnativeplayerkit-demo
//
//  Created by Dániel Zolnai on 07/08/2024.
//
import UIKit
import BBNativePlayerKit
import bbnativeshared
import AVKit

protocol VerticalVideoCellDelegate: AnyObject {
    func didEndPlayingCurrentVideo()
}

class VerticalVideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var playerContainerView: UIView!
    
    // The `String` for the data this cell is presenting.
    var representedId: String?
    
    weak var uiController: VerticalVideoViewController?
    
    var player: BBNativePlayerView?
        
    var playPauseAnimationIsRunning: Bool = false
    
    var playerShouldPlay: Bool = false {
        didSet {
            // This is set this way due to the fact that because of cell reuse, the player tends to
            // play videos that are off screen. This check is added to prevent that
            if !playerShouldPlay, let player = player {
                player.player.pause()
            } else if playerShouldPlay, let player = player {
                player.player.play()
            }
        }
    }
    
    weak var delegate: VerticalVideoCellDelegate?
    
    // MARK: - variables
    
    private var playing = false
    private var resumePlayerOnPause = false
    private var onStartedCalled = false
    private var startedPlayingAt: DispatchTime = .now()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        NotificationCenter.default.addObserver(self, selector: #selector(handleWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func configure(for asset: String) {
        playerContainerView.backgroundColor = .black
        addPlayerToView(for: asset)
    }
    
    private func addPlayerToView(for clipId: String) {
        removePlayerView()
        
        guard let uiController = uiController else { return }
       
        let embedJsonUrl = BBNativePlayer.createJsonEmbedUrl(
            baseUrl: "https://omroepwest.bbvms.com",
            appIndicator: "p",
            appId: "regiogroei_west_ios_videoplayer_vertical_preroll",
            contentIndicator: clipId.starts(with: "sourceid_string:") ? "q" : "c",
            contentId: clipId)
       
        player = BBNativePlayer.createPlayerView(
            uiViewController: uiController,
            frame: playerContainerView.frame,
            jsonUrl: embedJsonUrl,
            options: ["allowCollapseExpand": false, "autoPlay": true, "noChromeCast": true]
        )
        player?.delegate = self
        player?.isHidden = true
        player?.isUserInteractionEnabled = false
        player?.translatesAutoresizingMaskIntoConstraints = false
        playerContainerView.addSubview(player!)
        player?.leftAnchor.constraint(equalTo: playerContainerView.leftAnchor).isActive = true
        player?.topAnchor.constraint(equalTo: playerContainerView.topAnchor).isActive = true
        player?.rightAnchor.constraint(equalTo: playerContainerView.rightAnchor).isActive = true
        player?.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor).isActive = true
        player?.layoutIfNeeded()
    }
    
    @objc func playerEndPlay() {
        delegate?.didEndPlayingCurrentVideo()
    }
    
    func removePlayerView() {
        player?.player.pause()
        player?.isHidden = true
        player?.delegate = nil
        
        player?.destroy()
        player?.removeFromSuperview()
        player = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removePlayerView()
    }
    
    public func seekIfNotInTheBeginning() {
        if startedPlayingAt.distance(to: .now()) > DispatchTimeInterval.seconds(3) {
            player?.player.seek(offsetInSeconds: 0)
            startedPlayingAt = .now()
        }
   }
    
    private func ensurePlayerIsPlaying(_ playerView: BBNativePlayerView) {
        if !playerShouldPlay || playerView.player.state != nil {
            // Already paused or started, no need to ensure anything anymore
            return
        }
        // We check every 100ms if the player is playing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self else {
                return
            }
            if self.playerShouldPlay && playerView.player.state == nil {
                playerView.player.play()
                // Check again, just in case
                self.ensurePlayerIsPlaying(playerView)
            }
        }
    }
}

extension VerticalVideoCollectionViewCell {
    @objc private func handleWillEnterForegroundNotification(_ notification: Notification) {
        if let player = player, player.player.state == .paused {
            player.player.play()
        }
    }
}

// MARK: - BBNativePlayerViewDelegate
extension VerticalVideoCollectionViewCell: BBNativePlayerViewDelegate {
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didSetupWithJsonUrl url: String?) {
        player?.isHidden = false
        ensurePlayerIsPlaying(playerView)
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didFailWithError error: String?) {
        playing = false
    }

    func bbNativePlayerView(didTriggerEnded playerView: BBNativePlayerView) {
        playing = false
        onStartedCalled = false
        delegate?.didEndPlayingCurrentVideo()
    }
    
    func bbNativePlayerView(didTriggerPlaying playerView: BBNativePlayerView) {
        if !playerShouldPlay {
            playerView.player.pause()
        }
        playing = true
        startedPlayingAt = .now()
    }
    
    func bbNativePlayerView(didTriggerPause playerView: BBNativePlayerView) {
        let wasPlaying = playing
        playing = false
        if wasPlaying && resumePlayerOnPause {
            resumePlayerOnPause = false
            playerView.player.play()
        }
    }
    
    func bbNativePlayerView(playerView: BBNativePlayerView, didTriggerResize width: Int, height: Int) {
        // to keep playing when you exit fullscreen in case the video was already playing
        resumePlayerOnPause = true
    }
}
