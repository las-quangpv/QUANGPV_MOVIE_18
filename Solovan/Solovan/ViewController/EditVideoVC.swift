

import UIKit
import AVKit
import SwiftVideoGenerator

class EditVideoVC: BaseVC {

    @IBOutlet weak var lbEnd: UILabel!
    @IBOutlet weak var lbStart: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var cutterView: VideoTrimmer!
    @IBOutlet weak var shareView: BoderView!
    
    var videourl: URL!
    private var wasPlaying = false
    private var player: AVPlayer! {playerController.player}
    private var playerWithVideo: AVPlayer!
    var asset: AVAsset!
    var playerController = AVPlayerViewController()
    var currentTimeStr = ""
    var slctVideoUrl: URL?
    var startTime: Double = 0
    var endTime: Double = 0
    private var timeObserverToken: Any?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        slctVideoUrl = videourl
      
        setUpTrimView()
        addVideoView()
        setUpTrimVideo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if(player != nil ) {
            player?.pause()
        }
        if(playerWithVideo != nil ) {
            playerWithVideo?.pause()
        }
    }
    
    func removeAllView() {
        setUpTrimView()
        addVideoView()
        setUpTrimVideo()
    }
   
    func rePlayVideoWithUrl() {
        playerWithVideo = AVPlayer(url: self.slctVideoUrl ?? videourl)
        playerController.player = playerWithVideo
        self.playerWithVideo.play()
    }
    func addVideoView() {
        rePlayVideoWithUrl()
        videoView.addSubview(playerController.view)
        playerController.videoGravity = .resizeAspectFill
        playerController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerController.view.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
            playerController.view.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            playerController.view.topAnchor.constraint(equalTo: videoView.topAnchor),
            playerController.view.bottomAnchor.constraint(equalTo: videoView.bottomAnchor)
        ])
    }
   

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionShare(_ sender: Any) {
        if let newUrl = self.slctVideoUrl {
            let share = UIActivityViewController(activityItems: [newUrl], applicationActivities: nil)
            share.popoverPresentationController?.sourceView = self.shareView
            self.present(share, animated: true, completion: nil)
        }else {
            self.showMessage(message: "Save video error")
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if let videourl = self.slctVideoUrl {
            VideoGenerator.fileName = "Video_\(Date().timeIntervalSince1970)"
            VideoGenerator.current.splitVideo(withURL: videourl, atStartTime: Double(startTime), andEndTime: Double(endTime)) { (result) in
              switch result {
              case .success(let url):
                  self.hideLoading()
                  self.slctVideoUrl = url
                  self.showMessage(message: "Save video finish")
                  
                  do {
                      let fileName = "Video_\(Date().timeIntervalSince1970).m4v"
                       let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                       let outputURL = documentDirectory.appendingPathComponent(fileName)
                       try FileManager.default.copyItem(at: url, to: outputURL)
                      
                      SaveVideoModel.saveFile(fileModel: SaveVideoModel(fileName: fileName)) { sucess in
                          self.showMessage(message: "Save video finish")
                      }
                  }catch {
                      
                  }
              case .failure(let error):
                  self.showMessage(message: "Save video \(error)")
                  self.hideLoading()
                  
              }
            }
        }
    }
}

// MARK: -  trim video
extension EditVideoVC {
    // MARK: - Input
    @objc private func didBeginTrimming(_ sender: VideoTrimmer) {
        updateLabels()

        wasPlaying = (player.timeControlStatus != .paused)
        player.pause()

        updatePlayerAsset()
    }

    @objc private func didEndTrimming(_ sender: VideoTrimmer) {
        updateLabels()

        if wasPlaying == true {
            player.play()
        }

        updatePlayerAsset()
    }

    @objc private func selectedRangeDidChanged(_ sender: VideoTrimmer) {
        updateLabels()
    }

    @objc private func didBeginScrubbing(_ sender: VideoTrimmer) {
        updateLabels()

        wasPlaying = (player.timeControlStatus != .paused)
        player.pause()
    }

    @objc private func didEndScrubbing(_ sender: VideoTrimmer) {
        updateLabels()

        if wasPlaying == true {
            player.play()
        }
    }

    @objc private func progressDidChanged(_ sender: VideoTrimmer) {
        updateLabels()

        let time = CMTimeSubtract(cutterView.progress, cutterView.selectedRange.start)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    // MARK: - Private
    private func updateLabels() {
        startTime = cutterView.selectedRange.start.convertSecond
        endTime = cutterView.selectedRange.end.convertSecond
        currentTimeStr = cutterView.progress.displayString
        lbStart.text = cutterView.selectedRange.start.displayString
        lbEnd.text = cutterView.selectedRange.end.displayString
    }

    private func updatePlayerAsset() {
        let outputRange = cutterView.trimmingState == .none ? cutterView.selectedRange : asset.fullRange
        let trimmedAsset = asset.trimmedComposition(outputRange)
        if  trimmedAsset != player.currentItem?.asset {
            player.replaceCurrentItem(with: AVPlayerItem(asset: trimmedAsset))
        }
    }
    func setUpTrimView() {
        cutterView.minimumDuration = CMTime(seconds: 1, preferredTimescale: 600)
        cutterView.addTarget(self, action: #selector(didBeginTrimming(_:)), for: VideoTrimmer.didBeginTrimming)
        cutterView.addTarget(self, action: #selector(didEndTrimming(_:)), for: VideoTrimmer.didEndTrimming)
        cutterView.addTarget(self, action: #selector(selectedRangeDidChanged(_:)), for: VideoTrimmer.selectedRangeChanged)
        cutterView.addTarget(self, action: #selector(didBeginScrubbing(_:)), for: VideoTrimmer.didBeginScrubbing)
        cutterView.addTarget(self, action: #selector(didEndScrubbing(_:)), for: VideoTrimmer.didEndScrubbing)
        cutterView.addTarget(self, action: #selector(progressDidChanged(_:)), for: VideoTrimmer.progressChanged)
        cutterView.asset = asset
    }
    
    
    func setUpTrimVideo() {
        updatePlayerAsset()

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 30), queue: .main) { [weak self] time in
            guard let self = self else {return}
            let finalTime = self.cutterView.trimmingState == .none ? CMTimeAdd(time, self.cutterView.selectedRange.start) : time
            self.cutterView.progress = finalTime
        }

        updateLabels()
    }
}

