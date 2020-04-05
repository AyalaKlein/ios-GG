import Foundation

class Game {

    var id: String
    var name: String
    var description: String
    var score: Int
    var genre: String
    var userId: String
    
    init(id:String, name:String, description:String, score:Int, genre:String, userId:String) {
        self.id = id
        self.name = name
        self.description = description
        self.score = score
        self.genre = genre
        self.userId = userId
    }
    
    init(gameJson:[String:Any]) {
        self.id = gameJson["id"] as! String
        self.name = gameJson["name"] as! String
        self.description = gameJson["description"] as! String
        self.score = gameJson["score"] as! Int
        self.genre = gameJson["genre"] as! String
        self.userId = gameJson["userId"] as! String
    }
    
    func toJson() -> [String:Any] {
        var gameJson = [String:Any]()
        gameJson["id"] = self.id
        gameJson["name"] = self.name
        gameJson["description"] = self.description
        gameJson["score"] = self.score
        gameJson["genre"] = self.genre
        gameJson["userId"] = self.userId
        
        return gameJson
    }
}

