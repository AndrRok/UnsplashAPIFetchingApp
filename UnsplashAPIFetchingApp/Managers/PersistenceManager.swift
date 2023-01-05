//
//  PersistenceManager.swift
//  UnsplashAPIFetchingApp
//
//  Created by ARMBP on 1/5/23.
//

import Foundation
import RealmSwift

class ImagesRealm: Object{
    @Persisted dynamic var authorsName = ""
    @Persisted dynamic var imageUrl    = ""
    @Persisted dynamic var updatedAt: Date
    @Persisted dynamic var userHTML    = ""
    @Persisted dynamic var idOfImage   = ""//primary key (not for sorting)
    @Persisted dynamic var likes       = 0
    override static func primaryKey() -> String? { return "idOfImage" }
    @Persisted(primaryKey: true) var id: ObjectId//for sorting
}

class PersistenceManager{
    static let sharedRealm = PersistenceManager()
    
    private let realm = try! Realm()
    
    var item: Results<ImagesRealm> {return realm.objects(ImagesRealm.self).sorted(byKeyPath: "id", ascending: false)}//sorting
    
    func objectExist (primaryKey: String) -> Bool {//check if object already exists
            return realm.object(ofType: ImagesRealm.self, forPrimaryKey: primaryKey) != nil
    }
    
    
    func addFavorite(authorsName: String, imageUrl: String, updatedAt: Date, userHTML: String, likes: Int, id: String){
        let favoriteImage = ImagesRealm()
        favoriteImage.imageUrl    = imageUrl
        favoriteImage.authorsName = authorsName
        favoriteImage.updatedAt   = updatedAt
        favoriteImage.userHTML    = userHTML
        favoriteImage.likes       = likes
        favoriteImage.idOfImage   = id//primary key
        
        try! realm.write{ realm.add(favoriteImage) }
    }
    
    
    func deleteFavorite(item: ImagesRealm){
        try! realm.write{
            realm.delete(item) }
    }
    
    
    func deleteData(idForDelete: String){
            let realm = try! Realm()
            let data = realm.object(ofType: ImagesRealm.self, forPrimaryKey: idForDelete)
            if data != nil{
                try! realm.write {
                    realm.delete(data!)
                }
            }
        }
}

