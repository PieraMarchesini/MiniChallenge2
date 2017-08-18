//
//  FirebaseController.swift
//  FirebaseTest
//
//  Created by Julio Brazil on 28/04/17.
//  Copyright © 2017 Julio Brazil LTDA. All rights reserved.
//  essa porra funciona...
//

import Foundation
import Firebase

public class FirebaseController {
    static let instance = FirebaseController()
    
    let ref = FIRDatabase.database().reference()
    private var dataBase: FIRDataSnapshot
    
    private init() {
        ref.keepSynced(true)
        self.dataBase = FIRDataSnapshot()
        setObserver()
    }
    
    private func setObserver() {
        ref.observe(.value, with: { (snapshot) in
            self.dataBase = snapshot
        })
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                print("logado como \(String(describing: user?.uid))")
                if !auth.currentUser!.isEmailVerified {
                    auth.currentUser!.sendEmailVerification()
                    print("deslogado")
                }
            }
        }
    }
    
    public func getSnapshot() -> [String: AnyObject]{
        return dataBase.value as! [String: AnyObject]
    }
    
    public func add(user: Usuario, toGroup group: Group) {
        ref.child("Groups/\(group.id)/integrantes/\(user.tia)").setValue(user.tia)
        ref.child("Users/\(user.tia)/grupos/\(group.id)").setValue(group.id)
    }
    
    //Mark: - GROUP STUFF
    public func saveGroup(_ group: Group) {
        let temp = ref.child("Groups").childByAutoId()
        print(temp.key)
        group.id = temp.key
        temp.setValue(group.getDictionary())
        self.add(user: self.getUser(withId: group.lider), toGroup: group)
    }
    
    public func deleteGroup(withId id: String) {
        if self.getCurrentUserId() == self.getGroup(withId: id).lider {
            ref.child("Groups/\(id)").removeValue()
        }
        ref.child("Users/\(self.getCurrentUserId())/grupos").child(id).removeValue()
    }
    
    public func getGroups(completion: @escaping ([Group]) -> Void) {
        let snapshot = self.dataBase.childSnapshot(forPath: "Groups").children
        var groups: [Group] = []
        for group in snapshot {
            groups.append(Group(snapshot: group as! FIRDataSnapshot))
        }
        completion(groups)
    }
    
    public func getGroups(forUserWithId id: String, completion: ([Group]) -> Void) {
        let snapshot = self.dataBase.childSnapshot(forPath: "Users/\(id)/grupos").children
        var groups: [Group] = []
        for groupId in snapshot {
            groups.append(Group(snapshot: self.dataBase.childSnapshot(forPath: "Groups/\((groupId as! FIRDataSnapshot).key)")))
        }
        completion(groups)
    }
    
    public func getGroup(withId id: String, completion: (Group) -> Void ) {
        let snapshot = self.dataBase.childSnapshot(forPath: "Groups/\(id)")
        print(snapshot.hasChildren())
        let group = Group(snapshot: snapshot)
        completion(group)
    }
    
    //Mark: - USER STUFF
    private func saveUser(_ user: Usuario) {
        ref.child("Users/\(user.tia)").setValue(user.getDictionary())
    }
    
    public func registerUser(usuario: Usuario, senha: String, completion: @escaping () -> Void ){
        FIRAuth.auth()?.createUser(withEmail: usuario.email, password: senha, completion: { (user, error) in
            if error == nil {
                //send email verification and register info in database
                let request = user?.profileChangeRequest()
                request?.displayName = usuario.nome
                //request?.photoURL = ?
                
                self.saveUser(usuario)
                completion()
            }
        })
    }
    
    public func autenticateUser(email: String, senha: String, completion: @escaping (FIRUser, Error?) -> Void) {
        FIRAuth.auth()!.signIn(withEmail: email, password: senha) { (FIRUser, error) in
            print(error ?? "Log in successfull as \(FIRUser!.uid)")
            completion(FIRUser, error)
        }
    }
    
    public func checkEmailVerification(yes: () -> Void, no: () -> Void) {
        if (FIRAuth.auth()?.currentUser!.isEmailVerified)! {
            yes()
        } else {
            no()
        }
    }
    
    public func resendEmailVerification(completion: @escaping (Error?) -> Void ) {
        FIRAuth.auth()?.currentUser!.sendEmailVerification(completion: { (error) in
            completion(error)
        })
    }
    
    public func resetPassword(forTia tia: String, yes: @escaping () -> Void, no: @escaping () -> Void) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: "\(tia)@mackenzista.com.br") { error in
            if error != nil {
                no()
                // não foi possível enviar o email
            } else {
                yes()
                // email de redefinição de senha foi enviado
            }
        }
    }
    
    public func signUserOut() {
        try! FIRAuth.auth()!.signOut()
    }
    
    public func getCurrentUserId() -> String {
        let userEmail = FIRAuth.auth()?.currentUser?.email
        return (userEmail?.components(separatedBy: "@")[0])!
    }
    
    public func getUsers() -> [Usuario] {
        let snapshot = self.dataBase.childSnapshot(forPath: "Users").children //reduces the snapshot to a more specific sector
        var users: [Usuario] = [] //array of users
        for user in snapshot { //wlk through the users in the snapshot and add them to the array
            users.append(Usuario(snapshot: user as! FIRDataSnapshot))
        }
        return users //return the array of users
    }
    
    public func getUsers(forGroupWithId id: String) -> [Usuario] {
        let snapshot = self.dataBase.childSnapshot(forPath: "Groups/\(id)/integrantes").children
        var users: [Usuario] = []
        for userId in snapshot {
            users.append(Usuario(snapshot: self.dataBase.childSnapshot(forPath: "Users/\((userId as! FIRDataSnapshot).key)")))
        }
        return users //return the array of users
    }

    public func getUser(withId id: String) -> Usuario {
        let snapshot = self.dataBase.childSnapshot(forPath: "Users").childSnapshot(forPath: id)
        let user = Usuario(snapshot: snapshot)
        return user
    }
}
