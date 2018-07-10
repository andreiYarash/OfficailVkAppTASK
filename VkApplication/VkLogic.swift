import Foundation
import VK_ios_sdk


final class VkLogic{
    
    struct LogicGetJsonData:Decodable{
        struct ArrayObject:Decodable {
            let id:UInt?
            let first_name:String?
            let last_name:String?
        }
        let response:[ArrayObject?]
    }
    
    struct LogicWallJsonData:Decodable {
        struct Items:Decodable{
            let id:Int?
            let from_id:Int?
            let owner_id:Int?
            let date:Int?
            let marked_as_ads:Int?
            let post_type:String?
            let text:String?
        }
        let count:Int?
        let items:[Items?]
    }
    
    var userData:[LogicGetJsonData.ArrayObject?]
    var wallData:[LogicWallJsonData.Items?]
    
    init(){
        self.userData = [LogicGetJsonData.ArrayObject(id: 1, first_name: "name", last_name: "surname")]
        self.wallData = [LogicWallJsonData.Items(id: 1, from_id: 1, owner_id: 1, date: 1, marked_as_ads: 1, post_type: "typeP", text: "Some text")]
    }
    func requestUserData(tokenKey:String?){
        var urlString:String = "https://api.vk.com/method/users.get?&access_token="
        guard let truetokenKey = tokenKey else{return}
        urlString += truetokenKey
        urlString += "&v=5.80"
        
        guard let urlRequest = URL(string: urlString) else{return}
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                let stringdata = String(bytes: data, encoding: .utf8)
                print(stringdata!)
                let jsconDecoder = JSONDecoder()
            
                do {
                    
                    let resultMethod = try? jsconDecoder.decode(LogicGetJsonData.self, from: data)
                    let array = resultMethod?.response
                    guard let trueArray = array else{return}
                    print("Array:\(trueArray)")
                    print("RESULT IS :\(resultMethod)")
                    self.userData = trueArray
                    print("INSTANCE IS :\(self.userData)")
                }catch let errorParse{
                    print("parse error:\(errorParse)")
                }
                
            }
            
            }.resume()
        
    }
    
    func requestWallRecoders(tokenKey:String?){
        var urlString:String = "https://api.vk.com/method/wall.get?&access_token="
        guard let truetokenKey = tokenKey else{return}
        urlString += truetokenKey
        urlString += "&v=5.80"
        guard let urlRequest = URL(string: urlString) else{return}
        var wall:[LogicWallJsonData.Items?]
        URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                let stringdata = String(bytes: data, encoding: .utf8)
                print(stringdata!)
                let jsconDecoder = JSONDecoder()
                
                var wallDataLocal:LogicWallJsonData?
                
                do {
                    let resultMethod = try? jsconDecoder.decode(LogicWallJsonData.self, from: data)
                    let array = resultMethod?.items
                    print(array)
                    guard let trueArray = array else{return}
                    print("LOCAL:\(wallDataLocal)")
//                    print("Array:\(trueArray)")
//                    print("RESULT IS :\(resultMethod)")
                    //print("INSTANCE IS :\(self.instance)")
                }catch let errorParse{
                    print("parse error:\(errorParse)")
                }
                
            }
        
            }.resume()
    }
}
