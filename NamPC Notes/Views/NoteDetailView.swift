//
//  NoteDetailView.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 09/08/2023.
//

import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var settings: AddNewSettings
    @Environment(\.dismiss) var dismiss
    @ObservedObject var noteDetailViewModel: NoteCellViewModel
    var onCommit: (Note) -> Void = { _ in }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                TextField("Enter your note here", text: $noteDetailViewModel.note.content, axis: .vertical)
                    .padding(.all, 16)
                    .multilineTextAlignment(.leading)
                    .disabled(noteDetailViewModel.noteFromOtherUsers)
            }
            .padding()
            .toolbar {
                settings.addNew
                ? ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Save").foregroundColor(.primary)
                        .onTapGesture {
                            self.onCommit(self.noteDetailViewModel.note)
                            dismiss()
                        }
                } : nil
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(Images.grayBack)
                        .resizable()
                        .frame(width: 20, height: 16)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .navigationTitle("Note Detail")
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(noteDetailViewModel: NoteCellViewModel(note: Note(content: "Content", userID: "0001")))
    }
}
