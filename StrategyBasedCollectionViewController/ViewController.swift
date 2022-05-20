//
//  ViewController.swift
//  StrategyBasedCollectionViewController
//
//  Created by Houston Park on 2022/05/02.
//f

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Strategy1Action(_ sender: Any) {
        let editNickNameStrategy = EditNickNameConcreteStrategy()
        let vc = EditProfileStrategyViewController.create(strategy: editNickNameStrategy)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Strategy2Action(_ sender: Any) {
        let editSchoolStrategy = EditSchoolConcreteStrategy()
        let vc = EditProfileStrategyViewController.create(strategy: editSchoolStrategy)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func CategoryAction(_ sender: Any) {
        let editGradeStrategy = EditGradeConcreteStrategy()
        let vc = EditProfileStrategyViewController.create(strategy: editGradeStrategy)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

