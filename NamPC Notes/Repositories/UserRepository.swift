//
//  NoteRepository.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 09/08/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

extension UserDefaults {
    static let userKey = "UserKey"
}

protocol UserProtocol {
    var fireStoreDB: Firestore { get }
    func loadData()
    func updateUserName(user: User)
    func addUser(user: User)
}

class UserRepository: ObservableObject, UserProtocol {
    var fireStoreDB: Firestore = Firestore.firestore()
    
    @Published var user: User?
    private let userID: String
    
    init() {
        self.userID = Auth.auth().currentUser?.uid ?? ""
        loadData()
    }
    
    func loadData() {
        fireStoreDB.collection("users")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { (snapshot, err) in
                if let snapshot = snapshot {
                    let users = snapshot.documents.compactMap { document in
                        do {
                            let data = try document.data(as: User.self)
                            return data;
                        } catch {
                            print(err?.localizedDescription ?? "")
                        }
                        
                        return nil
                    }
                    self.user = users.first
                }
        }
    }
    
    func addUser(user: User) {
        print("addUser user = \(user)")
        do {
            var addedUser = user
            let userId = Auth.auth().currentUser?.uid
            addedUser.userID = userId
            try fireStoreDB.collection("users").addDocument(from: addedUser)
        } catch {
            fatalError("adde user failed")
        }
    }
    
    func updateUserName(user: User) {
        print("updateUserName user = \(user)")
        if let id = user.id, let userIDStr = user.userID, userID == userIDStr {
            do {
                try fireStoreDB.collection("users").document(id).setData(from: user, merge: true)
            } catch {
                fatalError("update user failed")
            }
        }
    }
}

