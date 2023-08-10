//
//  User.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 08/08/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String?
    var username: String
    var userID: String?
    @ServerTimestamp var createdTime: Timestamp?
}

#if DEBUG
let testDataUsers = [
    User(username: "nam")
]
#endif
