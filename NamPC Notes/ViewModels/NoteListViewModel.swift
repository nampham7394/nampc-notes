//
//  TaskListViewModel.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 09/08/2023.
//

import Foundation
import Combine

class NoteListViewModel: ObservableObject, Identifiable {
    @Published var noteRepository = NoteRepository()
    @Published var noteCellViewModels = [NoteCellViewModel]()
    @Published var otherNoteCellViewModels = [NoteCellViewModel]()
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        noteRepository.$notes.map { notes in
            notes.map { note in
                NoteCellViewModel(note: note)
            }
        }
        .assign(to: \.noteCellViewModels, on: self)
        .store(in: &cancelables)
        
        noteRepository.$otherUsersNotes.map { notes in
            notes.map { note in
                NoteCellViewModel(note: note)
            }
        }
        .assign(to: \.otherNoteCellViewModels, on: self)
        .store(in: &cancelables)
    }
    
    func addNote(note: Note) {
        noteRepository.addNote(note: note)
    }
    
    func updateNote(note: Note) {
        noteRepository.updateNote(note: note)
    }
}
