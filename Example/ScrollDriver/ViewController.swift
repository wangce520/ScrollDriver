//
//  ViewController.swift
//  ScrollDriver
//
//  Created by 王策 on 02/07/2023.
//  Copyright (c) 2023 王策. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton(frame: CGRectMake(20, 100, view.bounds.size.width - 40, 50))
        button.backgroundColor = .blue
        button.setTitle("TableView测试", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(tableViewButtonClick), for: .touchUpInside)
        
        let button2 = UIButton(frame: CGRectMake(20, 200, view.bounds.size.width - 40, 50))
        button2.backgroundColor = .blue
        button2.setTitle("CollectionView测试", for: .normal)
        view.addSubview(button2)
        button2.addTarget(self, action: #selector(collectionViewButtonClick), for: .touchUpInside)
    }   

    
    @objc func tableViewButtonClick(){
        let vc = CSTableViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func collectionViewButtonClick(){
        let vc = CSCollectionViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
