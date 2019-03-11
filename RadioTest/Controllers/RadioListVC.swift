//
//  ViewController.swift
//  RadioTest
//
//  Created by Amir Daliri on 11.03.2019.
//  Copyright © 2019 AmirDaliri. All rights reserved.
//

import UIKit

class RadioListVC: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    weak var radioPlayVC: RadioPlayVC?

    let radioPlayer = RadioPlayer()

    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        self.tableView.tableFooterView = UIView()
    }
}

extension RadioListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "radioListCell", for: indexPath) as! RadioListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showRadioPlayVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
}
