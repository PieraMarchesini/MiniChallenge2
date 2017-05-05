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
                print("logado como \(user?.uid)")
                if !auth.currentUser!.isEmailVerified {
                    auth.currentUser!.sendEmailVerification()
                    //lead to screen saying to confirm email, with a button to log out and leads to the log in screen
                    let alert = UIAlertController(title: "Atenção", message: "é necessário que você confirme seu email antes de utilizar o app, veja seu email @mackenzista", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.signUserOut() //Aka kick the user out
                    }))
                    
                    
                    print("deslogado")
                }
            }
        }
    }
    
    public func getSnapshot() -> [String: AnyObject]{
        return dataBase.value as! [String: AnyObject]
    }
    
    public func add(user: Usuario, toGroup group: Group) {
        ref.child("Groups").child(group.id).child("integrantes").child(user.tia).setValue(true)
        ref.child("Users").child(user.tia).child("grupos").child(group.id).setValue(true)
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
    
    public func getGroups(forUserWithId id: String) -> [Group] {
        let snapshot = self.dataBase.childSnapshot(forPath: "Users/\(id)/grupos").children
        var groups: [Group] = []
        for groupId in snapshot {
            groups.append(Group(snapshot: self.dataBase.childSnapshot(forPath: "Groups/\(groupId)")))
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
    
    public func registerUser(usuario: Usuario, senha: String){
        FIRAuth.auth()?.createUser(withEmail: usuario.email, password: senha, completion: { (user, error) in
            if error == nil {
                //send email verification and register info in database
                let request = user?.profileChangeRequest()
                request?.displayName = usuario.nome
                //request?.photoURL = ?
                
                self.saveUser(usuario)
            }
        })
    }
    
    public func autenticateUser(email: String, senha: String, completion: @escaping () -> Void) {
        FIRAuth.auth()!.signIn(withEmail: email, password: senha) { (FIRUser, Error) in
            print(Error)
            if Error == nil {
                completion()
            }
        }
    }
    
    public func signUserOut() {
        try! FIRAuth.auth()!.signOut()
        
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
            users.append(Usuario(snapshot: self.dataBase.childSnapshot(forPath: "Users/\(userId)")))
        }
        return users //return the array of users
    }

    public func getUser(withId id: String) -> Usuario {
        let snapshot = self.dataBase.childSnapshot(forPath: "Users").childSnapshot(forPath: id)
        let user = Usuario(snapshot: snapshot)
        return user
    }
}
