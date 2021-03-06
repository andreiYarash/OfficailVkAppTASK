import Foundation
import VK_ios_sdk


final class PrivateUserVkLogic{

    struct LogicGetJsonData:Decodable{
        
        struct ArrayObject:Decodable {
            let id:UInt?
            let first_name:String?
            let last_name:String?
        }
       
        let response:[ArrayObject?]
        
    }
    
    struct LogicWallJsonData:Decodable {
        
        struct ArrayItems:Decodable{
            let id:Int?
            let from_id:Int?
            let owner_id:Int?
            let date:Int?
            let marked_as_ads:Int?
            let post_type:String?
            let text:String?
        }
        
        struct InnerEntity:Decodable{
            let count:Int?
            let items:[ArrayItems?]
        }
        
        let response:InnerEntity?
     
    }
    
    struct LogicUserPhotosJsonData:Decodable{
        
        struct PhotoSizes:Decodable{
            let url:String?
        }
        struct PhotosParameters:Decodable{
            let sizes:[PhotoSizes?]
        }
        struct InnerItems:Decodable{
            let count:Int?
            let items:[PhotosParameters?]
        }
        
        
        let response:InnerItems
    }
    

    func requestUserData(tokenKey:String?, completionHandler: @escaping(LogicGetJsonData?, Error?)->Void){
        var urlString:String = "https://api.vk.com/method/users.get?&access_token="
        guard let trueTokenKey = tokenKey else{return}
        urlString += trueTokenKey
        urlString += "&v=5.80"
        
        guard let urlRequest = URL(string: urlString) else{return}
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                
                guard err == nil else{
                    print("Error in URLSesion")
                    return
                }

                let jsonDecoder = JSONDecoder()
                
                do{
                    let resultMethod = try jsonDecoder.decode(LogicGetJsonData.self, from: data)
                    
                    completionHandler(resultMethod,nil)
                    
                } catch{
                    print("Error in DO scope")
                    completionHandler(nil,err)
                    
                }
                
                
            }
            }.resume()
        
    }
    
    func requestWallRecoders(tokenKey:String?,completionHandler:@escaping (LogicWallJsonData?,Error?)->Void){
        var urlString:String = "https://api.vk.com/method/wall.get?&access_token="
        guard let trueTokenKey = tokenKey else{return}
        urlString += trueTokenKey
        urlString += "&v=5.80"
        guard let urlRequest = URL(string: urlString) else{return}
        print(urlString)
        URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                guard err == nil else{
                    print("Error in URLSesion")
                    return
                    
                }
             
                let jsconDecoder = JSONDecoder()
                
                do {
                    let resultMethod = try jsconDecoder.decode(LogicWallJsonData.self, from: data)
                    completionHandler(resultMethod,nil)
                
                } catch{
                    completionHandler(nil,err)
                }
                
            }
        
            }.resume()
    }
    
    func requestUserPhotos(tokenKey:String?,completionHandler:@escaping (LogicUserPhotosJsonData?,Error?)->Void){
        var urlString:String = "https://api.vk.com/method/photos.get?profile&access_token="
        guard let trueTokenKey = tokenKey else{return}
        urlString += trueTokenKey
        urlString += "&v=5.80"
        guard let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                guard let data = data else{return}
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
