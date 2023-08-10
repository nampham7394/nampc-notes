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

protocol NoteProtocol {
    var fireStoreDB: Firestore { get }
    func loadData()
    func addNote(note: Note)
    func updateNote(note: Note)
}

class NoteRepository: ObservableObject, NoteProtocol {
    let fireStoreDB: Firestore = Firestore.firestore()
    
    @Published var notes = [Note]()
    @Published var otherUsersNotes = [Note]()
    
    init() {
        loadData()
        loadOtherUsersNote()
    }
    
    func loadData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        fireStoreDB.collection("notes")
            .order(by: "createdTime")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { (snapshot, err) in
            if let snapshot = snapshot {
                self.notes = snapshot.documents.compactMap { document in
                    do {
                        let data = try document.data(as: Note.self)
                        return data;
                    } catch {
                        print(err?.localizedDescription ?? "")
                    }
                    
                    return nil
                }
            }
        }
    }
    
    func loadOtherUsersNote() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        fireStoreDB.collection("notes")
            .order(by: "createdTime")
            .addSnapshotListener { (snapshot, err) in
            if let snapshot = snapshot {
                self.otherUsersNotes = snapshot.documents.compactMap { document in
                    do {
                        let data = try document.data(as: Note.self)
                        return data;
                    } catch {
                        print(err?.localizedDescription ?? "")
                    }
                    
                    return nil
                }.filter { note in
                    note.userID != userID
                }
            }
        }
    }
    
    func addNote(note: Note) {
        do {
            var addedNote = note
            let userId = Auth.auth().currentUser?.uid
            addedNote.userID = userId
            try fireStoreDB.collection("notes").addDocument(from: addedNote)
        } catch {
            fatalError("adde note failed")
        }
    }
    
    func updateNote(note: Note) {
        if let id = note.id {
            do {
                try fireStoreDB.collection("notes").document(id).setData(from: note, merge: true)
            } catch {
                fatalError("update note failed")
            }
        }
    }
}

