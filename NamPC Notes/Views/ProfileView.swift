//
//  ProfileView.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 09/08/2023.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userViewModel = UserViewModel(user: User(username: ""))
    @ObservedObject var userRepository = UserRepository()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                TextField("Enter your name here", text: $userViewModel.user.username, axis: .vertical)
                    .padding(.all, 16)
                    .multilineTextAlignment(.leading)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("Save").foregroundColor(.primary)
                        .onTapGesture {
                            userViewModel.user.id == nil ? userRepository.addUser(user: userViewModel.user) : userRepository.updateUserName(user: userViewModel.user)
                            dismiss()
                        }
                    }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Back").foregroundColor(.primary)
                        .onTapGesture {
                            dismiss()
                        }
                    }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
