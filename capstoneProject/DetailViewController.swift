//
//  DetailViewController.swift
//  capstoneProject
//
//  Created by Yan Yan on 08/08/2017.
//  Copyright © 2017 Yan Yan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    
    @IBAction func messages(_ sender: Any) {
        let controller = ClassroomMessagesController(collectionViewLayout: UICollectionViewFlowLayout())
        for i in 0 ..< mainControl!.Mentors.count{
            if mainControl?.Mentors[i].name == mainControl?.curr_mentor?.name{
                controller.classroom = mainControl?.Mentors[i]
            }
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    //@IBOutlet weak var itemWithin: UILabel!
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IDID", for: indexPath) as! CustomCellInCollection
        if indexPath.item<7{
            cell.customLabel?.text = week[indexPath.item]
        } else if indexPath.item-8 < 1{
            cell.customLabel?.text = ""
        }else{
            cell.customLabel?.text = String(indexPath.item-8)
        }
        for i in mainControl!.curr_mentor?.time ?? [0]{
            if String(i) == cell.customLabel?.text && cell.customLabel?.text != ""{
                cell.backgroundColor = .gray
                //print(cell.customLabel?.text)
            }  
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 7, height: view.frame.width / 7)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10.0, right: -1.0)
        return sectionInsets
    }
    
    let week = ["Mon","Tues","Wed","Thur","Fri","Sat","Sun"]
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cal: UICollectionView!
    @IBOutlet weak var subjects: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var Name: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? ViewController
        viewController?.mentorControl = self
    }
    
    var mainControl: ViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Name.text = mainControl!.curr_mentor?.name
        year.text = "\(mainControl!.curr_mentor!.year)"
        var subjects1 = ""
        var first = true
        for i in mainControl!.curr_mentor!.subject{
            if first == true {
                subjects1 = i
                first = false
                //print(subjects1)
            }else{
                subjects1 = subjects1 + ", " + i
                //print(subjects1)
            }
        }
        subjects.text = subjects1
        email.text = mainControl!.curr_mentor!.email
        if Name.text == "Loiic"{
            profileImage.image = #imageLiteral(resourceName: "Loiic")
        }else if Name.text == "Tom"{
            profileImage.image = #imageLiteral(resourceName: "Tom")
        }
        print(mainControl!.curr_mentor?.time)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:0,left:10,bottom:0,right:10)
        layout.itemSize = CGSize(width: view.frame.width / 7 - 5, height: view.frame.width / 7 - 5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cal.collectionViewLayout = layout
    }
}

