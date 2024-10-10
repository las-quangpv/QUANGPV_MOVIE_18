

import UIKit
import AVKit
import AVFoundation
class MyVideoAIVC: BaseVC {

    @IBOutlet weak var viewNotEmpty: UIView!
    @IBOutlet weak var clv: UICollectionView!
    @IBOutlet weak var viewEmpty: UIView!
    
    var saveVideoList: [SaveVideoModel] = []
    var isAI = false
    override func viewDidLoad() {
        super.viewDidLoad()

        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "MyVideoAICell", bundle: nil), forCellWithReuseIdentifier: "MyVideoAICell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkEmpty()
    }
    
    func checkEmpty() {
        let list = SaveVideoModel.readSaveFileJson()
        if(isAI) {
            saveVideoList = list.filter({ saveModel in
                return saveModel.fileName.contains("mp4")
            })
        }else {
            saveVideoList = list.filter({ saveModel in
                return saveModel.fileName.contains("m4v")
            })
        }
        viewNotEmpty.isHidden = saveVideoList.count == 0
        clv.reloadData()
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: 200, height: 200)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyVideoAIVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyVideoAICell", for: indexPath) as! MyVideoAICell
        let saveModel = saveVideoList[indexPath.row]
        cell.lbTitle.text = saveModel.fileName
        cell.lbContent.text = saveModel.duration
        cell.itemMoreBlock =  { index in
            let model = self.saveVideoList[index]
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { action in
                if let newUrl = model.url {
                    let viewShare = UIView(frame: CGRect(x: SCREEN_WIDTH/2 - 32, y: 100, width: 1, height: 1))
                    self.view.addSubview(viewShare)
                    let share = UIActivityViewController(activityItems: [newUrl], applicationActivities: nil)
                    share.popoverPresentationController?.sourceView = viewShare
                    self.present(share, animated: true, completion: nil)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                SaveVideoModel.removeFile(fileModel: model)
                self.showMessage(message: "Delete file finish!")
                self.checkEmpty()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                
            }))
            self.present(alert, animated: true)
        }
        if let url = saveModel.url {
            cell.iv.image = createVideoThumbnail(from: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let saveModel = saveVideoList[indexPath.row]
        if let url = saveModel.url {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = clv.frame.width/2 - 8
        return CGSize(width: size, height: size)
    }
}
