//
//  GoogleAuth.swift
//  Sudoku
//
//  Created by Illia Suvorov on 04.04.2025.
//

import GoogleSignIn
import FirebaseAuth

enum GoogleAuthSerivceError: Error {
    case resultIsNull
}

class GoogleAuthSerivce {
    
    static func handle(url: URL) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
    
    func authorize(presenter: UIViewController, clientID: String) async throws -> GIDSignInResult {
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        return try await withCheckedThrowingContinuation(isolation: MainActor.shared) { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { result, error in
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }
                
                guard let result = result else {
                    continuation.resume(throwing: GoogleAuthSerivceError.resultIsNull)
                    return
                }
                continuation.resume(returning: result)
            }
        }
    }
}
 
