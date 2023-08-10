//
//  ContentView.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 08/08/2023.
//

import SwiftUI

struct NoteListView: View {
    
    @ObservedObject var noteListViewModel = NoteListViewModel()
    @StateObject var settings = AddNewSettings()

    @ViewBuilder var currentUserSection: some View {
        if noteListViewModel.noteCellViewModels.count > 0 {
            Section("Current User") {
                ForEach(noteListViewModel.noteCellViewModels) { noteCellVM in
                    NavigationLink {
                        NoteDetailView(noteDetailViewModel: noteCellVM) { note in
                            self.noteListViewModel.addNote(note: note)
                        }
                        .onAppear {
                            settings.addNew = false
                        }
                    } label: {
                        NoteCell(noteCellVM: noteCellVM)
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder var otherUsersSection: some View {
        if noteListViewModel.otherNoteCellViewModels.count > 0 {
            Section("Other Users") {
                ForEach(noteListViewModel.otherNoteCellViewModels) { noteCellVM in
                    NavigationLink {
                        NoteDetailView(noteDetailViewModel: noteCellVM) { note in
                            self.noteListViewModel.addNote(note: note)
                        }
                        .onAppear {
                            settings.addNew = false
                        }
                    } label: {
                        NoteCell(noteCellVM: noteCellVM)
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    currentUserSection
                    otherUsersSection
                }
                .listStyle(.grouped)
            }
            .navigationTitle("Notes")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        NoteDetailView(noteDetailViewModel: NoteCellViewModel(note: Note(content: ""))) { note in
                            self.noteListViewModel.addNote(note: note)
                        }
                        .onAppear {
                            settings.addNew = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Add New Task")
                        }
                        .padding()
                    }
                }
            }
        }
        .environmentObject(settings)
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
