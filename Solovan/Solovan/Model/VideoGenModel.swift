import Foundation

class VideoGenModel: NSObject {
    var H: Int = 0
    var W: Int = 0
    var filePrefix: String = ""
    var guidanceScale: Int = 0
    var imageGuidanceScale: Int = 0
    var instantResponse: Bool = false
    var nSamples: Int = 0
    var negativePrompt: String = ""
    var numFrames: Int = 0
    var outdir: String = ""
    var prompt: String = ""
    var safetychecker: Bool = false
    var scheduler: String = ""
    var seconds: Int = 0
    var seed: Int = 0
    var steps: Int = 0
    var temp: Bool = false
    
    override init() {
        
    }
    
    init(dic: [String: Any]) {
        if let val = dic["H"] as? Int {
            H = val
        }
        
        if let val = dic["W"] as? Int {
            W = val
        }
        
        if let val = dic["file_prefix"] as? String {
            filePrefix = val
        }
        
        if let val = dic["guidance_scale"] as? Int {
            guidanceScale = val
        }
        
        if let val = dic["image_guidance_scale"] as? Int {
            imageGuidanceScale = val
        }
        
        if let val = dic["instant_response"] as? String {
            instantResponse = val == "yes"
        }
        
        if let val = dic["n_samples"] as? Int {
            nSamples = val
        }
        
        if let val = dic["negative_prompt"] as? String {
            negativePrompt = val
        }
        
        if let val = dic["num_frames"] as? Int {
            numFrames = val
        }
        
        if let val = dic["outdir"] as? String {
            outdir = val
        }
        
        if let val = dic["prompt"] as? String {
            prompt = val
        }
        
        if let val = dic["safetychecker"] as? String {
            safetychecker = val == "yes"
        }
        
        if let val = dic["scheduler"] as? String {
            scheduler = val
        }
        
        if let val = dic["seconds"] as? Int {
            seconds = val
        }
        
        if let val = dic["seed"] as? Int {
            seed = val
        }
        
        if let val = dic["steps"] as? Int {
            steps = val
        }
        
        if let val = dic["temp"] as? String {
            temp = val == "yes"
        }
    }
}

class DataSucessV2Model: NSObject {
    var id: Int = 0
    var meta: Meta? = nil
    
    override init() {
        
    }
    
    init(dic: [String: Any]) {
        if let val = dic["id"] as? Int {
            id = val
        }
        
        if let metaDic = dic["meta"] as? [String: Any] {
            meta = Meta(dic: metaDic)
        }
    }
}

class Meta: NSObject {
    var H: Int = 0
    var W: Int = 0
    var filePrefix: String = ""
    var guidanceScale: Int = 0
    var imageGuidanceScale: Int = 0
    var instantResponse: Bool = false
    var nSamples: Int = 0
    var negativePrompt: String = ""
    var numFrames: Int = 0
    var outdir: String = ""
    var prompt: String = ""
    var safetychecker: Bool = false
    var scheduler: String = ""
    var seconds: Int = 0
    var seed: Int = 0
    var steps: Int = 0
    var temp: Bool = false
    
    override init() {
        
    }
    
    init(dic: [String: Any]) {
        if let val = dic["H"] as? Int {
            H = val
        }
        
        if let val = dic["W"] as? Int {
            W = val
        }
        
        if let val = dic["file_prefix"] as? String {
            filePrefix = val
        }
        
        if let val = dic["guidance_scale"] as? Int {
            guidanceScale = val
        }
        
        if let val = dic["image_guidance_scale"] as? Int {
            imageGuidanceScale = val
        }
        
        if let val = dic["instant_response"] as? String {
            instantResponse = val == "yes"
        }
        
        if let val = dic["n_samples"] as? Int {
            nSamples = val
        }
        
        if let val = dic["negative_prompt"] as? String {
            negativePrompt = val
        }
        
        if let val = dic["num_frames"] as? Int {
            numFrames = val
        }
        
        if let val = dic["outdir"] as? String {
            outdir = val
        }
        
        if let val = dic["prompt"] as? String {
            prompt = val
        }
        
        if let val = dic["safetychecker"] as? String {
            safetychecker = val == "yes"
        }
        
        if let val = dic["scheduler"] as? String {
            scheduler = val
        }
        
        if let val = dic["seconds"] as? Int {
            seconds = val
        }
        
        if let val = dic["seed"] as? Int {
            seed = val
        }
        
        if let val = dic["steps"] as? Int {
            steps = val
        }
        
        if let val = dic["temp"] as? String {
            temp = val == "yes"
        }
    }
}
