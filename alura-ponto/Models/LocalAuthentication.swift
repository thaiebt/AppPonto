//
//  LocalAuthentication.swift
//  alura-ponto
//
//  Created by c94289a on 15/03/22.
//

import Foundation
import LocalAuthentication

class AuthenticationLocal {
    private let authenticatorContext =  LAContext()
    private var error: NSError?
    
    func authorizeUser(completion: @escaping(_ authentication: Bool) -> Void) {
        if authenticatorContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authenticatorContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "É necessário atenticação para deletar um recibo.") { success, error in
                completion(success)
            }
        }
    }
}
