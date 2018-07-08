import Foundation
import VK_ios_sdk

struct LogicVkService:Decodable{
    struct ArrayObject:Decodable {
        let id:Int?
        let first_name:String?
        let last_name:String?
    }
    let response:ArrayObject
}

struct VkApiMethodGetMethod{
    var tokenKey:String?
    var result:LogicVkService?
   
    
    mutating func requestData() ->LogicVkService?{
         var urlString:String = "https://api.vk.com/method/users.get?&access_token="
   
        guard let truetokenKey = tokenKey else{return nil}
      urlString += truetokenKey
        urlString += "&v=5.80"
   
        print(urlString)
        
        guard let urlRequest = URL(string: urlString) else{return nil}
        
        
        var resultMethod:LogicVkService?
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, err) in
            DispatchQueue.main.async {
                guard let data = data else{return}
                
                let jsconDecoder = JSONDecoder()
                
                do {
                  
                    resultMethod = try? jsconDecoder.decode(LogicVkService.self, from: data)
                    
                    

                }catch let errorParse{
                    print("parse error:\(errorParse)")
                }
                
            }
        }.resume()
     return resultMethod
    }
    
}
