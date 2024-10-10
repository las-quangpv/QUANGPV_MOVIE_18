

import UIKit

class NewTagsPopupVC: BaseVC, HSVColorDelegate {

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lbColor: UILabel!
    @IBOutlet weak var colorSelectView: BoderView!
    @IBOutlet weak var clv: UICollectionView!
    @IBOutlet weak var enterTextView: EnterTextView!
    @IBOutlet weak var colorView: BoderView!
    @IBOutlet var colorPicker: SwiftHSVColorPicker!
    var selectedColor: UIColor = UIColor.white

    var colorModel: ColorModel!
    var colorList = [ColorModel]()
    var tagPopupBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbColor.setFontSize(size: 12)
        colorList = ColorModel.readSaveFileJson()
        colorModel = colorList[0]
        loadSelectColor()

        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "ColorCell", bundle: nil), forCellWithReuseIdentifier: "ColorCell")
        
        enterTextView.styleTagPopup()
        self.dismissKeyboard()
        
        colorPicker.setViewColor(selectedColor)
        colorPicker.delegate = self
        
        btnDone.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: 18)
    }
    
    func loadSelectColor() {
        selectedColor = UIColor(hex: colorModel.colorHex)
        colorSelectView.backgroundColor = selectedColor
        lbColor.text = selectedColor.toHexString()
    }

    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        let txt = enterTextView.tf.text ?? ""
        if(txt.isEmpty) {
            // showtoas
            showMessage(message: "You have not entered a tag name.")
        }else {
            self.colorModel.tag = txt
            ColorModel.saveFile(colorModel: self.colorModel)
            showMessage(message: "Tag created successfully")
            
            self.dismiss(animated: true) {
                if let tagPopupBlock = self.tagPopupBlock {
                    tagPopupBlock()
                }
            }
        }
    }
    
    @IBAction func actionDone(_ sender: Any) {
        colorView.isHidden = true
        
        self.colorModel = ColorModel(colorHex: selectedColor.toHex() ?? 0x000000, tag: "")
        colorList.insert(colorModel, at: 0)
        clv.reloadData()
    }
    
    func selectColor(color: UIColor) {
        let hex = color.toHexString() ?? "0x000000"
        lbColor.text = hex
        colorSelectView.backgroundColor = color
        selectedColor = color
    }
    
}

extension NewTagsPopupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        
        let colorModel = colorList[indexPath.row]
        if(indexPath.row == colorList.count - 1) {
            cell.iv.isHidden = false
            cell.ivTick.isHidden = true
        }else {
            cell.iv.isHidden = true
            if(self.colorModel.checkEqual(colorModel: colorModel)) {
                cell.boderView.borderWidth = 2
                cell.ivTick.isHidden = false
            }else {
                cell.boderView.borderWidth = 0
                cell.ivTick.isHidden = true
            }
        }
        cell.boderView.backgroundColor = UIColor(hex: colorModel.colorHex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == colorList.count - 1) {
            colorView.isHidden = false
        }else {
            self.colorModel = colorList[indexPath.row]
            loadSelectColor()
            clv.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 34, height: 34)
    }
}
