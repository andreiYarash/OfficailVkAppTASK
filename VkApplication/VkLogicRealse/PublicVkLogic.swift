import Foundation
import VK_ios_sdk

final class PublicVkLogic{
    
    struct LogicUserPhotosJsonData:Decodable{
        
        struct PhotoSizes:Decodable{
            let type:String?
            let url:String?
            
        }
        struct PhotosParameters:Decodable{
            let id:Int8?
            let sizes:[PhotoSizes?]
        }
        struct InnerItems:Decodable{
            let count:Int?
            let items:[PhotosParameters?]
        }
        
        
        let response:InnerItems
    }
    private let serviceVkKey:String = "f57c64cff57c64cff57c64cfadf5197b8dff57cf57c64cfae3d78bdb68adb6129a9e1f8"
    
    func requestUserPhotos(tokenKey:String?,completionHandler:@escaping (LogicUserPhotosJsonData?,Error?)->Void){
        var urlString:String = "https://api.vk.com/method/photos.get?profile&access_token="
        guard let trueTokenKey = tokenKey else{return}
        urlString += trueTokenKey
        urlString += "&v=5.80"
        guard let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                
                print(String(bytes: data, encoding: .utf8))
                
                let stringData = String(bytes: data, encoding: .utf8)
                print("Photos Json:\(stringData)")
                guard err == nil else{
                    print("Error in URLSession")
                    return
                }
                
                let jsonDecoder = JSONDecoder()
                
                do{
                    let resultMethod = try jsonDecoder.decode(LogicUserPhotosJsonData.self, from: data)
                    completionHandler(resultMethod,nil)
                } catch{
                    completionHandler(nil,err)
                    print(error)
                }
            }
            }.resume()
    }
}
