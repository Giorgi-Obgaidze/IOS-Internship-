//
//  LoadingViewController.swift
//  Currency-app
//
//  Created by giorgi obgaidze on 2/7/21.
//  Copyright © 2021 giorgi obgaidze. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(named: "bg-gradient-end")
        
        spinner.color = UIColor(named: "accent")
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
