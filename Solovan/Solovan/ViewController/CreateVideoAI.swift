

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class CreateVideoAI: BaseVC {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tf: UITextField!
    
    @IBOutlet weak var viewShare: BoderView!
    @IBOutlet weak var viewFunc: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var nextView: BoderView!
    var fileName = ""
    var videoUrl: URL?
    var movieModel: MovieModel?
    var playerController = AVPlayerViewController()
    private var player: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movieModel = movieModel {
            nextView.isHidden = true
            tf.isEnabled = false
            tf.text = movieModel.title
            viewFunc.isHidden = false
            emptyView.isHidden = true
            addVideoView(videourl: videoUrl!)
        }
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if(player != nil ) {
            player?.pause()
        }
       
    }
    
    func addVideoView(videourl: URL) {
        player = AVPlayer(url:  videourl)
        playerController.player = player
        self.player.play()
        
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
    
    @IBAction func actionNext(_ sender: Any) {
        let text = tf.text ?? ""
        if(text.isEmpty) {
            showMessage(message: "You have not entered content to create a video.")
            return
        }
        showLoading()
        showMessageLong(message: "Creating video. It may take a few minutes to create, please wait.")
        
        NetworkManager.newInstance.createVideo(txt: text) { dataSucessV2Model in
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                if let dataSucessV2Model = dataSucessV2Model {
                    print("trungnc: id: \(dataSucessV2Model.id)")
                    NetworkManager.newInstance.fetchDreambooth(requestID: "\(dataSucessV2Model.id)") { textToVideoModel in
                        if let textToVideoModel = textToVideoModel {
                            if(textToVideoModel.output.count > 0) {
                                let urlStr = textToVideoModel.output[0]
                                print("\(textToVideoModel.output[0])")
                                NetworkManager.newInstance.downloadVideo(urlString: urlStr) { fileName, urlFinish in
                                    DispatchQueue.main.sync {
                                        self.hideLoading()
                                    }
                                    
                                    if(!fileName.isEmpty) {
                                        DispatchQueue.main.sync {
                                            if let urlFinish = urlFinish {
                                                self.fileName = fileName
                                                self.videoUrl = urlFinish
                                                self.viewFunc.isHidden = false
                                                self.addVideoView(videourl: urlFinish)
                                            }else {
                                                self.showMessage(message: "Invalid content. Please try again.")
                                            }
                                           
                                        }
                                    }
                                }
                            }
                        }else {
                            DispatchQueue.main.sync {
                                self.hideLoading()
                            }
                        }
                        
                    }
                }else {
                    self.showMessage(message: "Invalid content. Please try again.")
                }
                
            }
        }
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if(fileName.isEmpty) {
            self.showMessage(message: "Invalid content. Please try again.")
            return
        }
        SaveVideoModel.saveFile(fileModel: SaveVideoModel(fileName: fileName)) { sucess in
            self.showMessage(message: "Save video finish")
        }
    }
    
    @IBAction func actionShare(_ sender: Any) {
       // "1726471358.0139872b9088e5-67f8-47f5-969d-b7229cc02ff5.mp4"
        if let newUrl = videoUrl {
            let share = UIActivityViewController(activityItems: [newUrl], applicationActivities: nil)
            share.popoverPresentationController?.sourceView = self.viewShare
            self.present(share, animated: true, completion: nil)
        }else {
            self.showMessage(message: "Save video error")
        }
    
    }
    
}
