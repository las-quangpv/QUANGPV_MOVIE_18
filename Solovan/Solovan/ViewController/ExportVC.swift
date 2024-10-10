

import UIKit
import QuickLook

class ExportVC: BaseVC, QLPreviewControllerDataSource {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var clv: UICollectionView!
    
    var listFile: [FileSaveFDFModel] = []
    var pdfURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clv.delegate = self
        clv.dataSource = self
        clv.register(UINib(nibName: "FileCell", bundle: nil), forCellWithReuseIdentifier: "FileCell")
        
        listFile = FileSaveFDFModel.readSaveFileJson()
        checkEmpty()
    }
    
    func checkEmpty() {
        if(listFile.count == 0) {
            emptyView.isHidden = false
            clv.isHidden = true
        }else {
            emptyView.isHidden = true
            clv.isHidden = false
            clv.reloadData()
        }
    }
    
    func formatFileSizeInMB(bytes: Int64) -> String {
        let fileSizeInMB = Double(bytes) / 1024.0 / 1024.0
        return String(format: "%.2f mb", fileSizeInMB)
    }
    
    func openPDF(fileURL: URL) {
        self.pdfURL = fileURL
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // QLPreviewControllerDataSource methods
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return pdfURL! as QLPreviewItem
        }
    
}

extension ExportVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as! FileCell
        let fileModel = listFile[indexPath.row]
        
        cell.lbName.text = "\(fileModel.fileName).pdf"
        cell.lbSize.text = formatFileSizeInMB(bytes: fileModel.fileSize ?? 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fileModel = listFile[indexPath.row]
        let alertController = UIAlertController(title: "Notification", message: "", preferredStyle: .alert)
       
        let openAction = UIAlertAction(title: "Open", style: .default) { action in
            if let url = fileModel.url {
                self.openPDF(fileURL: url)
            }
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { [self] action in
            FileSaveFDFModel.removeFile(fileModel: fileModel)
            listFile = FileSaveFDFModel.readSaveFileJson()
            checkEmpty()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
           
        }
        
        // Thêm các action vào alert controller
        alertController.addAction(openAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Hiển thị alert
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: clv.frame.width, height: 50)
    }
}
