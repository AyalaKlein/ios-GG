import Foundation
import Firebase
import FirebaseStorage

class FireBaseModel {
    var ref:DatabaseReference?
    var storageRef:StorageReference?
    
    static var instance: FireBaseModel = FireBaseModel()
    
    static func getInstance()->FireBaseModel {
        return instance
    }
    
    private init() {
        ref = nil
        storageRef = nil
    }
    
    func initRefs() {
        ref = Database.database().reference()
        storageRef = Storage.storage().reference();
    }
    
    func registerUser(email:String, password:String, callback:@escaping (User?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                callback(nil)
            } else {
                callback(user?.user)
            }
        })
    }
    
    func signIn(email:String, password:String, callback:@escaping (User?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                callback(nil)
            } else {
                callback(user?.user)
            }
        }
    }
    
    func connectedUser() -> User? {
        return Auth.auth().currentUser;
    }
    
    func getAutoKey(table:String)->String? {
        return self.ref?.child(table).childByAutoId().key
    }
    
    func getAllItemsInTable(table:String, callback:@escaping ([String:[String:Any]]?)->Void) {
        self.ref?.child(table).observeSingleEvent(of: .value, with: { (snapshot) in
            callback(snapshot.value as? [String:[String:Any]])
        })
    }
    
    func addItemToTable(table:String, key:String, value:[String:Any]) {
        self.ref?.child(table).child(key).setValue(value)
    }
    
    func removeItemFromTable(table:String, key:String) {
        self.ref?.child(table).child(key).removeValue()
    }

    func saveImageToFirebase(image:UIImage, name:(String),
                             callback:@escaping (String?)->Void){
        let imageRef = storageRef!.child("images/"+name+".jpg")
        let imageData = image.jpegData(compressionQuality: 0.8)
        if imageData != nil {
            imageRef.putData(imageData!, metadata: nil) { (metadata, error) in
                imageRef.downloadURL { url, error in
                    if error != nil {
                        // error
                    } else {
                        callback(url?.absoluteString)
                    }
                }            }
            
        }
    }
    
    func downloadImage(name:String, callback:@escaping (UIImage?)->Void) {
        let islandRef = storageRef!.child("images/"+name+".jpg")
        islandRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if (error != nil) {
                callback(nil)
            } else {

                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    func removeImage(name:String) {
        storageRef!.child("images/"+name+".jpg").delete { (error) in
        }
    }
}

