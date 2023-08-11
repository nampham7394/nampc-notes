//
//  ContentView.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 08/08/2023.
//

import SwiftUI

struct NoteListView: View {
    
    @ObservedObject var noteListViewModel = NoteListViewModel()
    @State var isAddNew = false
    
    func onCommit(note: Note) {
        self.noteListViewModel.addNote(note: note)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    CurrentUserSection(noteListViewModel: noteListViewModel, isAddNew: $isAddNew)
                    OtherUsersSection(noteListViewModel: noteListViewModel, isAddNew: $isAddNew)
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Notes")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        NoteDetailView(noteDetailViewModel:
                                        NoteCellViewModel(note: Note(content: "")),
                                       onCommit: self.onCommit,
                                       isAddNew: .constant(true)
                        )
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Add New Task")
                        }
                        .padding(.all, 8)
                        .padding(.trailing, 0)
                    }
                }
            }
        }
    }
}

struct CurrentUserSection: View {
    @ObservedObject var noteListViewModel: NoteListViewModel
    @State var isAddNew: Binding<Bool>
    
    func onCommit(note: Note) {
        self.noteListViewModel.addNote(note: note)
    }

    var body: some View {
        if noteListViewModel.noteCellViewModels.count > 0 {
            Section("Current User") {
                ForEach(noteListViewModel.noteCellViewModels) { noteCellVM in
                    NavigationLink {
                        NoteDetailView(noteDetailViewModel: noteCellVM,
                                       onCommit: self.onCommit,
                                       isAddNew: .constant(false))
                    } label: {
                        NoteCell(noteCellVM: noteCellVM)
                    }
                }
                
            }
        }
    }
}

struct OtherUsersSection: View {
    @ObservedObject var noteListViewModel: NoteListViewModel
    @State var isAddNew: Binding<Bool>
    
    func onCommit(note: Note) {
        self.noteListViewModel.addNote(note: note)
    }

    var body: some View {
        if noteListViewModel.otherNoteCellViewModels.count > 0 {
            Section("Other Users") {
                ForEach(noteListViewModel.otherNoteCellViewModels) { noteCellVM in
                    NavigationLink {
                        NoteDetailView(noteDetailViewModel: noteCellVM,
                                       onCommit: self.onCommit,
                                       isAddNew: .constant(false))
                    } label: {
                        NoteCell(noteCellVM: noteCellVM)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView()
    }
}

struct NoteCell: View {
    
    @ObservedObject var noteCellVM: NoteCellViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Text(noteCellVM.note.content)
        }
    }
}
