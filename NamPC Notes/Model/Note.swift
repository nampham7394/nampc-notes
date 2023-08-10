//
//  Task.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 08/08/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Note: Codable {
    @DocumentID var id: String?
    var content: String
    var userID: String?
    @ServerTimestamp var createdTime: Timestamp?
}

#if DEBUG
let testDataNotes = [
    Note(content: "Test Content", userID: "0001")
]
#endif
