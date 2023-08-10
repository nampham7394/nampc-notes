//
//  UserViewModel.swift
//  NamPC Notes
//
//  Created by Pham Cao Nam on 10/08/2023.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var userRepository = UserRepository()
    @Published var user: User
    
    var username: String = ""
    private var cancelables = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        
        userRepository.$user.map { user in
            user?.username ?? ""
        }
        .assign(to: \.username, on: self)
        .store(in: &cancelables)
        
        userRepository.$user.map { user in
            user ?? User(username: "")
        }
        .assign(to: \.user, on: self)
        .store(in: &cancelables)
    }
}
