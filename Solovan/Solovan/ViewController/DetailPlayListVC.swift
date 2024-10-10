

import UIKit

class DetailPlayListVC: BaseVC {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var clv: UICollectionView!
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var boderExportView: BoderView!
    @IBOutlet weak var btnExport: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var movieList: [MyMovieModel] = []
    var playListModel: PlaylistModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnExport.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: 18)
        
       // let newColor = convertColor(backgroundColorHex: playListModel.color)
        self.view.backgroundColor = UIColor(hex: playListModel.color).withAlphaComponent(0.8)
        self.boderExportView.backgroundColor = UIColor(hex: playListModel.color).withAlphaComponent(0.8)
//        lbTitle.textColor = UIColor(hex: newColor)
//        btnBack.tintColor = UIColor(hex: newColor)
//        btnAdd.tintColor = UIColor(hex: newColor)
//        btnExport.setTitleColor(UIColor(hex: newColor), for: .normal)
        
        lbTitle.text = playListModel.title
        
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "MediaPhotosCell", bundle: nil), forCellWithReuseIdentifier: "MediaPhotosCell")
        
        movieList = MyMovieModel.readSaveFileJson().filter({ myMovieModel in
            return playListModel.movieStrList.contains(myMovieModel.id)
        })
        checkEmpty()
    }
    
    func checkEmpty() {
        if(movieList.count == 0) {
            emptyView.isHidden = false
            clv.isHidden = true
        }else {
            emptyView.isHidden = true
            clv.isHidden = false
            clv.reloadData()
        }
    }
    
    func exportToPDF(fileName: String, competion: ((URL?) -> Void)){
        let pdfMetaData = [
            kCGPDFContextCreator: "\(playListModel.title)",
            kCGPDFContextAuthor: "\(playListModel.title)"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 596
        let pageHeight = 842
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            let textAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Pacifico-Regular", size: 24)
            ]
            
            // Vẽ tiêu đề của playlist
            let title = "\(playListModel.title)"
            title.draw(at: CGPoint(x: 16, y: 16), withAttributes: textAttributes as [NSAttributedString.Key : Any])
            
            // Vẽ icon của playlist
            let iconRect = CGRect(x: 16, y: 64, width: 110, height: 150)
            if let image = loadImageFromDoc(fileName: playListModel.icon) {
                image.draw(in: iconRect)
            }
            
            // Khởi tạo yOffset để xác định vị trí tiếp theo của hình ảnh và văn bản
            var yOffset = 220 // Đặt yOffset đủ lớn để các hình không chồng lấn lên icon playlist
            var xOffset = 16
            let moviesStrList = playListModel.movieStrList
            
            let movieList = MyMovieModel.readSaveFileJson().filter { myMovieModel in
                return playListModel.movieStrList.contains(myMovieModel.id)
            }
            
            for myMovieModel in movieList {
                if let movieImage = loadImageFromDoc(fileName: myMovieModel.posterStr) {
                    let movieIconRect = CGRect(x: xOffset, y: yOffset, width: 110, height: 150)
                    movieImage.draw(in: movieIconRect)
                    
                    yOffset += 160
                }
                
              
            }
        }
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")
        
        do {
            try data.write(to: fileURL)
            competion(fileURL)
        } catch {
            competion(nil)
        }
    }


    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        let vc = AddMovieVC()
        vc.movieSelectIdList = playListModel.movieStrList.components(separatedBy: ";")
        vc.addMovieBlock = { [self] selectListId in
            playListModel.movieStrList = selectListId.joined(separator: ";")
            movieList = MyMovieModel.readSaveFileJson().filter({ myMovieModel in
                return playListModel.movieStrList.contains(myMovieModel.id)
            })
            checkEmpty()
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func actionExport(_ sender: Any) {
        var list = PlaylistModel.readSaveFileJson()
        
        let index = list.firstIndex { playListModel in
            return playListModel.id == playListModel.id
        } ?? -1
        if(index > -1) {
            list[index] = playListModel
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    writeString(string: jsonString, fileName: PlaylistModel.PLAYLIST_JSON)
                }
            }catch {
                
            }
        }
        let fileName = "\(Date().timeIntervalSince1970)"
        showLoading()
        exportToPDF(fileName: fileName) { url in
            self.hideLoading()
            if let url = url {
                FileSaveFDFModel.saveFile(fileModel: FileSaveFDFModel(fileName: fileName)) { success in
                    self.hideLoading()
                    showMessage(message: "Create pdf file successfully!")
                }
            }else {
                showMessage(message: "Create pdf file error!")
            }
        }
    }
    
}

extension DetailPlayListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPhotosCell", for: indexPath) as! MediaPhotosCell
        
        let myMovieModel = movieList[indexPath.row]
        let image = loadImageFromDoc(fileName: myMovieModel.posterStr)
        cell.iv.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (clv.frame.width)/2 - 15, height: 233)
    }
}
