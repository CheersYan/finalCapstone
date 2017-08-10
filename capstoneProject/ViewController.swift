//
//  ViewController.swift
//  capstoneProject
//
//  Created by Yan Yan on 07/08/2017.
//  Copyright © 2017 Yan Yan. All rights reserved.
//

import UIKit
import Foundation
import WilddogAuth
import WilddogCore
import WilddogSync

class ViewController: UITableViewController {
    var testing = "testing"
    var curr_mentor: student?
    var Mentors = [student]()
    var subjects = ["English","Maths","History","Science","Language"]
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subjects.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let grayView = UIView()
        grayView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 12)
        headerLabel.text = subjects[section]
        grayView.addSubview(headerLabel)
        return grayView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subject = subjects[section]
        var studentInSec = [student]()
        
        for i in Mentors {
            for j in i.subject{
                if j == subject {studentInSec.append(i)}
            }
        }
        //print(studentInSec.count)
        return studentInSec.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subject = subjects[indexPath.section]
        var studentInSec = [student]()
        
        for i in Mentors {
            for j in i.subject{
                //print(j)
                if j == subject {studentInSec.append(i)}
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID") as! UITableViewCell
        if studentInSec.count > 0{
            cell.textLabel?.text = studentInSec[indexPath.row].name ?? "name"
            cell.detailTextLabel?.text = String(studentInSec[indexPath.row].year) ?? "year"
        }
        //cell.backgroundColor = .red
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("updating and setting up the the database")
        let options = WDGOptions(syncURL: "https://wd9511660706xzjqap.wilddogio.com")
        WDGApp.configure(with: options)
        let wilddogeReference = WDGSync.sync().reference()
        
//        wilddogeReference.setValue(["name": "TOm"])
//        let studentReference = wilddogeReference.childByAutoId()
//        //studentReference.setValue(["subject":"1"])
//        studentReference.updateChildValues(["subject":[0: "English", 1: "Math"]])
//        studentReference.updateChildValues(["name": "Tom"])
//        studentReference.updateChildValues(["year": 2017])
//        studentReference.updateChildValues(["email": "18019128998@protonmail.com"])
//        studentReference.updateChildValues(["time": [2,7,6,7,20]])
        print("finished databse setting")
        
        wilddogeReference.observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshots = snapshot.children.allObjects as! [WDGDataSnapshot]
            for snapshot in snapshots{
                let dict = snapshot.value as? [String: Any]
                //print(dict?["subject"])
                let email = dict?["email"] as? String ?? ""
                let name = dict?["name"] as? String ?? ""
                let subject = dict?["subject"] as? [String] ?? ["nothing"]
                let time = dict?["time"] as? [Int] ?? [0]
                let year = dict?["year"] as? Int ?? 2017
                
                let student1 = student(email:email, name:name, subject:subject, time:time, year:year)
                self.Mentors.append(student1)
            }
            self.tableView.reloadData()
        }){ (err) in
            print("fail to observe")
        }
    }
    
    var mentorControl: DetailViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as? DetailViewController
        detailViewController?.mainControl = self
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subject = subjects[indexPath.section]
        var studentInSec = [student]()
        
        for i in Mentors {
            for j in i.subject{
                if j == subject {studentInSec.append(i)}
            }
        }
        
        curr_mentor = studentInSec[indexPath.row]
    }
}

