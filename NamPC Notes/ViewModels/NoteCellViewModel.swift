//
//  TaskCellViewModel.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 09/08/2023.
//

import Foundation
import Combine
import FirebaseAuth

class NoteCellViewModel: ObservableObject, Identifiable {
    @Published var noteRepository = NoteRepository()
    @Published var note: Note
    var id: String = ""
    @Published var noteFromOtherUsers = false
    
    private var cancelables = Set<AnyCancellable>()
    
    init(note: Note) {
        self.note = note
        
        $note.compactMap { note in
            note.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancelables)
        
        $note.compactMap { note in
            if let userID = note.userID {
               return userID != Auth.auth().currentUser?.uid
            } else {
                return false
            }
        }
        .assign(to: \.noteFromOtherUsers, on: self)
        .store(in: &cancelables)
        
        $note
            .dropFirst()
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .sink { note in
            self.noteRepository.updateNote(note: note)
        }
        .store(in: &cancelables)
    }
}
