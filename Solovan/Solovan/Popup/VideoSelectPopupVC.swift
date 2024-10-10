

import UIKit
import AVFoundation

class VideoSelectPopupVC: UIViewController {
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var clv: UICollectionView!
    
    var saveVideoList: [SaveVideoModel] = []
    var videoSelectBlock:((SaveVideoModel) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "MyVideoAICell", bundle: nil), forCellWithReuseIdentifier: "MyVideoAICell")
        
        checkEmpty()
        // Do any additional setup after loading the view.
    }
    
    func checkEmpty() {
         saveVideoList = SaveVideoModel.readSaveFileJson()
        if(saveVideoList.count == 0) {
            viewEmpty.isHidden = false
            clv.isHidden = true
        }else {
            viewEmpty.isHidden = true
            clv.isHidden = false
            clv.reloadData()
        }
        
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

    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }

}

extension VideoSelectPopupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return saveVideoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyVideoAICell", for: indexPath) as! MyVideoAICell
        let saveModel = saveVideoList[indexPath.row]
        cell.lbTitle.text = saveModel.fileName
        cell.lbContent.text = saveModel.duration
        
        if let url = saveModel.url {
            cell.iv.image = self.createVideoThumbnail(from: url)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let saveModel = saveVideoList[indexPath.row]
        self.dismiss(animated: true) {
            self.videoSelectBlock(saveModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = clv.frame.height
        return CGSize(width: size, height: size)
    }
}
