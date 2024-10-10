//
//  FilterVideoVC.swift
//  Movie018
//
//  Created by Trung Nguyễn on 17/9/24.
//

import UIKit
import AVKit

class FilterVideoVC: BaseVC {
    @IBOutlet weak var clvFilter: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var shareView: BoderView!
    private var playerWithVideo: AVPlayer!
    var asset: AVAsset!
    var fileName = ""
    var playerController = AVPlayerViewController()
    var slctVideoUrl: URL?
    var strSelectedEffect = ""
    var videourl: URL!
    var thumImg: UIImage?
    var filterSelcted = 100
    var ListFilterNames = [
        "",
        "CISharpenLuminance",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CIColorClamp",
        "CIColorInvert",
        "CIColorMonochrome",
        "CISpotLight",
        "CIColorPosterize",
        "CIBoxBlur",
        "CIDiscBlur",
        "CIGaussianBlur",
        "CIMaskedVariableBlur",
        "CIMedianFilter",
        "CIMotionBlur",
        "CINoiseReduction"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slctVideoUrl = videourl
        setUpCollectionView()
        addVideoView()
        // Do any additional setup after loading the view.
    }
    
    func setUpCollectionView() {
        self.clvFilter.delegate = self
        self.clvFilter.dataSource = self
        self.clvFilter.register(UINib(nibName: "FilterVideoCell", bundle: nil), forCellWithReuseIdentifier: "FilterVideoCell")
    }
    
    func rePlayVideoWithUrl() {
        playerWithVideo = AVPlayer(url: self.slctVideoUrl ?? videourl)
        playerController.player = playerWithVideo
        self.playerWithVideo.play()
    }
    func addVideoView() {
        self.thumImg = generateThumbnail(path: videourl)
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
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch  {
            return nil
        }
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
        if(fileName.isEmpty) {
            self.showMessage(message: "You have not created any effects for the video.")
            return
        }
        SaveVideoModel.saveFile(fileModel: SaveVideoModel(fileName: fileName)) { sucess in
            self.showMessage(message: "Save video finish")
        }
    }
}

extension FilterVideoVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ListFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterVideoCell", for: indexPath) as! FilterVideoCell
        if(indexPath.row == 0) {
            cell.iv.image = thumImg
        }else {
            if let convertImage = thumImg {
                cell.iv.image = convertImageToBW(filterName: ListFilterNames[indexPath.row], image: convertImage)
            }
        }
        
        
        if self.filterSelcted == indexPath.row {
            cell.boderView.borderWidth = 2
        } else {
            cell.boderView.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.playerWithVideo.pause()
        self.showLoading()
        self.filterSelcted = indexPath.row
        self.strSelectedEffect = ListFilterNames[indexPath.row]
        self.clvFilter.reloadData()
        
        if(self.strSelectedEffect == "") {
            self.hideLoading()
            self.slctVideoUrl = videourl
            self.rePlayVideoWithUrl()
        }else {
            addfiltertoVideo(strfiltername: strSelectedEffect, strUrl: videourl) { [self] urlFinish in
                DispatchQueue.main.sync {
                    self.hideLoading()
                    self.slctVideoUrl = urlFinish
                    self.rePlayVideoWithUrl()
                }
            } failure: { error in
                DispatchQueue.main.sync {
                    self.hideLoading()
                }

            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 86)
    }
    func convertImageToBW(filterName : String ,image:UIImage) -> UIImage {
        let filter = CIFilter(name: filterName)
 
        let ciInput = CIImage(image: image)
        filter?.setValue(ciInput, forKey: "inputImage")

        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
    
    func addfiltertoVideo(strfiltername : String, strUrl : URL, success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        let filter = CIFilter(name:strfiltername)
        let asset = AVAsset(url: strUrl)
        fileName = "Video_\(Date().timeIntervalSince1970).m4v"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputURL = documentDirectory.appendingPathComponent(fileName)
        //AVVideoComposition
        let composition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            filter?.setValue(source, forKey: kCIInputImageKey)
            let output = filter?.outputImage!.cropped(to: request.sourceImage.extent)
            request.finish(with: output!, context: nil)
            
        })
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputFileType = AVFileType.mov
        exportSession.outputURL = outputURL
        exportSession.videoComposition = composition
        
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .completed:
                success(outputURL)
                
            case .failed:
                failure(exportSession.error?.localizedDescription)
                
            case .cancelled:
                failure(exportSession.error?.localizedDescription)
                
            default:
                failure(exportSession.error?.localizedDescription)
            }
        })
    }
}
