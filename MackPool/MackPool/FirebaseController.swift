//
//  FirebaseController.swift
//  FirebaseTest
//
//  Created by Julio Brazil on 28/04/17.
//  Copyright © 2017 Julio Brazil LTDA. All rights reserved.
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
                print("logado")
                if !auth.currentUser!.isEmailVerified {
                    auth.currentUser!.sendEmailVerification()
                    //lead to screen saying to confirm email, with a button to log out and leads to the log in screen
                    print("email não verificado")
                    try! FIRAuth.auth()!.signOut()
                    print("deslogado")
                }
            } else {
                // No user is signed in.
                print("não logado")
            }
        }
    }
    
    public func getSnapshot() -> [String: AnyObject]{
        return dataBase.value as! [String: AnyObject]
    }
    
    //Mark: - GROUP STUFF
    public func saveGroup(_ group: Group) {
        ref.child("Groups").child("\(group.id)").setValue(group.getDictionary())
    }
    
    public func getGroups() -> [Group] {
        let snapshot = self.dataBase.childSnapshot(forPath: "Groups").children
        var groups: [Group] = []
        for group in snapshot {
            groups.append(Group(snapshot: group as! FIRDataSnapshot))
        }
        return groups
    }
    
    public func getGroup(withId id: String) -> Group {
        let snapshot = self.dataBase.childSnapshot(forPath: "Group").childSnapshot(forPath: id)
        let group = Group(snapshot: snapshot)
        return group
    }
    
    //Mark: - USER STUFF
    private func saveUser(_ user: Usuario) {
        ref.child("Users").child("\(user.tia)").setValue(user.getDictionary())
    }
    
    public func registerUser(email: String, senha: String, usuario: Usuario){
        FIRAuth.auth()?.createUser(withEmail: email, password: senha, completion: { (user, error) in
            if error == nil {
                //send email verification and register info in database
                let request = user?.profileChangeRequest()
                request?.displayName = usuario.nome
                //request?.photoURL = ?
                
                self.saveUser(usuario)
            }
        })
    }
    
    public func autenticateUser(email: String, senha: String) {
        FIRAuth.auth()!.signIn(withEmail: email, password: senha)
    }
    
    public func getUsers() -> [Usuario] {
        let snapshot = self.dataBase.childSnapshot(forPath: "Users").children //reduces the snapshot to a more specific sector
        var users: [Usuario] = [] //array of users
        for user in snapshot { //wlk through the users in the snapshot and add them to the array
            users.append(Usuario(snapshot: user as! FIRDataSnapshot))
        }
        return users //return the array of users
    }

    public func getUser(withId id: String) -> Usuario {
        let snapshot = self.dataBase.childSnapshot(forPath: "Users").childSnapshot(forPath: id)
        let user = Usuario(snapshot: snapshot)
        return user
    }
}
