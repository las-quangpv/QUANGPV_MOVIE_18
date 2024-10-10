

import Foundation
import UIKit
import Alamofire

class NetworkManager: NSObject {
    static let newInstance: NetworkManager = NetworkManager()
    
    func convertImageToBase64(image: UIImage) -> String {
        if let imageData = image.jpegData(compressionQuality: 0.4) {
            return imageData.base64EncodedString(options: .lineLength64Characters)
        }
        return ""
    }
    
    func downloadVideo(urlString: String, completion: @escaping (String, URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion("", nil)
            return
        }
        
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                do {
                    let name = "\(Date().timeIntervalSince1970)\(url.lastPathComponent)"
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let savedURL = documentsURL.appendingPathComponent(name)
                    try FileManager.default.moveItem(at: tempLocalUrl, to: savedURL)
                    print("File saved to: \(savedURL)")
                    completion(name, savedURL)
                } catch {
                    print("Error saving file: \(error)")
                    completion("", nil)
                }
            } else {
                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
                completion("", nil)
            }
        }
        downloadTask.resume()
    }
    
    func createVideo(txt: String, completion: @escaping (DataSucessV2Model?) -> Void) {
        // Tạo header cho request
        var request = URLRequest(url: URL(string: "https://stablediffusionapi.com/api/v5/text2video")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Tạo body của request
        let parameters: [String: Any] = [
            "key": "aEhGn3mZOmFSsXMs5b0H3MajWK9Zj8JaVzbTB9gyflaxuhEl2Tk9CpwsybPg",
            "prompt": txt,
            "negative_prompt": "Low Quality",
            "scheduler": "UniPCMultistepScheduler",
            "seconds": 3
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        // Tạo URLSession
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let json = convertDataToJSON(data: data) as? Dictionary {
                print("Received JSON: \(json)")

                let model = DataSucessV2Model(dic: json)
                completion(model)
                return
            }
            completion(nil)
        }
        
        // Thực hiện request
        dataTask.resume()
    }
    
    func fetchDreambooth(requestID: String, completion: @escaping (TextToVideoModel?) -> Void) {
        // Tạo URLRequest với URL của API
        var request = URLRequest(url: URL(string: "https://stablediffusionapi.com/api/v4/dreambooth/fetch")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Tạo body của request
        let parameters: [String: Any] = [
            "key": "aEhGn3mZOmFSsXMs5b0H3MajWK9Zj8JaVzbTB9gyflaxuhEl2Tk9CpwsybPg",
            "request_id": requestID
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        // Tạo URLSession
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
          
            guard let data = data else {
                print("2222222222222: ")
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.fetchDreambooth(requestID: requestID, completion: completion)
                }
                return
            }
            
            if let json = convertDataToJSON(data: data) as? Dictionary {
                print("ReceivedV2 JSON: \(json)")
                let model = TextToVideoModel(dic: json)
                if(model.status != "success") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.fetchDreambooth(requestID: requestID, completion: completion)
                    }
                }else {
                    completion(model)
                    return
                }
               
                
            }
            
        }
        
       
        dataTask.resume()
    }
}
