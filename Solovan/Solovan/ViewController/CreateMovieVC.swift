

import UIKit
import CollectionViewWaterfallLayout
class CreateMovieVC: BaseVC {
    @IBOutlet weak var ivPoster: BoderUIImageView!
    @IBOutlet weak var tfOverview: EnterTextView!
    @IBOutlet weak var tfUrl: EnterTextView!
    @IBOutlet weak var tfDate: EnterTextView!
    @IBOutlet weak var tfTitle: EnterTextView!
    @IBOutlet weak var constrantHeightPhotos: NSLayoutConstraint!
    @IBOutlet weak var clvPhotos: UICollectionView!
    @IBOutlet weak var constrantHeightTags: NSLayoutConstraint!
    @IBOutlet weak var clvTags: UICollectionView!
    
    var maxHeightPhoto: [Int] = []
    var photoList: [UIImage] = []
    var selectTagList:[ColorModel] = []
    var myMovieModel:MyMovieModel?
    var colorList:[ColorModel] = []
    var isAddPoster = false
    
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
        
        for i in 0...100 {
            if(i == 0) {
                let size = 110
                maxHeightPhoto.append(size)
                cellSizes.append(CGSize(width: 110, height: size))
            }else {
                let random = Int(arc4random_uniform((UInt32(100))))
                let size = 50 + random
                maxHeightPhoto.append(size)
                cellSizes.append(CGSize(width: 110, height: size))
            }
            
        }
        
        return cellSizes
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tagsFlowLayout = TagsFlowLayout(alignment: .left ,minimumInteritemSpacing: 15, minimumLineSpacing: 12, sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        clvTags.collectionViewLayout = tagsFlowLayout
        
        // register cell
        clvTags.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
        clvTags.delegate = self
        clvTags.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let number = self.numberOfRowsInCollectionView()
            self.constrantHeightTags.constant = CGFloat(number ?? 0) * 40 + CGFloat(number ?? 0) * 12
        }
        
        let _ = cellSizes
        let flowLayout = CollectionViewWaterfallLayout()
        flowLayout.columnCount = 3
        clvPhotos.collectionViewLayout = flowLayout
        clvPhotos.register(UINib(nibName: "MediaPhotosCell", bundle: nil), forCellWithReuseIdentifier: "MediaPhotosCell")
        
        clvPhotos.delegate = self
        clvPhotos.dataSource = self
        
        photoList.insert(UIImage(named: "ic_media_add")!, at: 0)
        reloadHeightListPhoto()
        
        editMovie()
    }
    
    func editMovie() {
        if let myMovieModel = myMovieModel {
            ivPoster.isHidden = false
            ivPoster.image = loadImageFromDoc(fileName: myMovieModel.posterStr)
            tfTitle.setText(str: myMovieModel.title)
            tfDate.setText(str: myMovieModel.date)
            tfUrl.setText(str: myMovieModel.urlSt)
            tfOverview.setText(str: myMovieModel.overview)
            
            let photoStrList = myMovieModel.mediaListStr.components(separatedBy: ";")
            photoStrList.forEach { fileName in
                let image = loadImageFromDoc(fileName: fileName) ?? UIImage()
                photoList.append(image)
            }
            reloadHeightListPhoto()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorList = ColorModel.readSaveFileJson()
    }
    
    func reloadHeightListPhoto() {
        clvPhotos.reloadData()
        
        let max = Int(maxHeightPhoto.max() ?? 1)
        var row = round(Double(photoList.count/3))
        if(row == 0) {
            row = 1
        }
        constrantHeightPhotos.constant = (row + 1) * Double(max) + (row - 1) * 8
    }
    
    func numberOfRowsInCollectionView() -> Int? {
        guard clvTags.collectionViewLayout is UICollectionViewFlowLayout else {
            return nil
        }
        
        // Lấy ra chiều cao của từng hàng
        let rowHeight = 52.0
        
        // Lấy ra contentSize của UICollectionView
        let contentHeight = clvTags.contentSize.height
        
        // Tính số hàng dựa trên chiều cao và contentSize
        let numberOfRows = Int(contentHeight / rowHeight)
        
        return numberOfRows
    }

    @IBAction func actionBack(_ sender: Any) {
        if let viewControllers = self.navigationController?.viewControllers {
            for controller in viewControllers {
                if controller is MyMovieVC { 
                    self.navigationController?.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    @IBAction func actionCreatePoster(_ sender: Any) {
        isAddPoster = true
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = ["public.image"] // Chỉ cho phép chọn ảnh
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func actionCreateTag(_ sender: Any) {
        let vc = NewTagsPopupVC()
        vc.tagPopupBlock = { [self] in
            colorList = ColorModel.readSaveFileJson()
            clvTags.reloadData()
            let number = self.numberOfRowsInCollectionView()
            self.constrantHeightTags.constant = CGFloat(number ?? 0) * 40 + CGFloat(number ?? 0) * 12
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
       
        var posterStr = ""
        if let image = ivPoster.image {
            imageToDoc(image: image, completion: { fileName in
                posterStr = fileName
            })
        }
        let id = "\(Date().timeIntervalSince1970)"
        let title = tfTitle.getText()
        let date = tfDate.getText()
        let urlStr = tfUrl.getText()
        let overView = tfOverview.getText()
        
        if(title.isEmpty) {
            showMessage(message: "You have not entered a name!")
            return
        }
        
        let tagStr = selectTagList.map { colorModel in
            return colorModel.tag
        }.joined(separator: ";")
        
        var mediaStrList = [String]()
        var newPhotoList = photoList
        newPhotoList.remove(at: 0)
        newPhotoList.forEach { image in
            imageToDoc(image: image) { fileName in
                mediaStrList.append(fileName)
            }
        }
        
        let myMovieModel = MyMovieModel(id: id,date: date, posterStr: posterStr, urlSt: urlStr, overview: overView, title: title, tags: tagStr, mediaListStr: mediaStrList.joined(separator: ";"))
        
        if let movieModel = self.myMovieModel {
           // edit
            myMovieModel.id = movieModel.id
            var list = MyMovieModel.readSaveFileJson()
            let index = list.firstIndex { model in
                return model.id == movieModel.id
            } ?? -1
            if(index != -1) {
                list[index] = myMovieModel
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: list.map{$0.toString()}, options: JSONSerialization.WritingOptions.prettyPrinted)
                    if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        writeString(string: jsonString, fileName: MyMovieModel.MY_MOVIE_JSON)
                    }
                }catch {
                    
                }
                showMessage(message: "Movie edit successfully")
            }
        }else {
            MyMovieModel.saveFile(movieModel: myMovieModel)
            showMessage(message: "Movie created successfully")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

extension CreateMovieVC: UICollectionViewDelegate, UICollectionViewDataSource,  CollectionViewWaterfallLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(clvPhotos == collectionView) {
            return photoList.count
        }
        return colorList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(clvPhotos == collectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaPhotosCell", for: indexPath) as! MediaPhotosCell
            cell.iv.image = photoList[indexPath.row]
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let colorModel = colorList[indexPath.row]
        cell.lb.text = colorModel.tag
        
        let index = selectTagList.firstIndex { model in
            return colorModel.checkEqual(colorModel: model)
        } ?? -1
        if(index == -1) {
            cell.lb.textColor = UIColor(hex: colorModel.colorHex)
            cell.boderView.borderColor = UIColor(hex: colorModel.colorHex)
            cell.boderView.backgroundColor = UIColor.clear
        }else {
            cell.lb.textColor = UIColor(hex: 0xFFFFFF).withAlphaComponent(0.8)
            cell.boderView.borderColor = UIColor(hex: colorModel.colorHex)
            cell.boderView.backgroundColor = UIColor(hex: colorModel.colorHex)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(clvPhotos == collectionView) {
            if(indexPath.row == 0) {
                isAddPoster = false
                
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.mediaTypes = ["public.image"] // Chỉ cho phép chọn ảnh
                present(imagePickerController, animated: true, completion: nil)
            }
        }
        if(clvTags == collectionView) {
            let colorModel = colorList[indexPath.row]
            let index = selectTagList.firstIndex { model in
                return colorModel.checkEqual(colorModel: model)
            } ?? -1
            if(index == -1) {
                selectTagList.append(colorModel)
            }else {
                selectTagList.remove(at: index)
            }
            clvTags.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if(collectionView == clvPhotos) {
            if(indexPath.row < cellSizes.count) {
                return cellSizes[indexPath.item]
            }else {
                return CGSize(width: 110, height: 110)
            }
        }
        return CGSize(width: 110, height: 110)
        
    }
}

extension CreateMovieVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                if(isAddPoster) {
                    ivPoster.isHidden = false
                    ivPoster.image = selectedImage
                }else {
                    photoList.insert(selectedImage, at: 1)
                    reloadHeightListPhoto()
                }
               
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
