//
//  ViewController.swift
//  Currency-app
//
//  Created by giorgi obgaidze on 2/7/21.
//  Copyright © 2021 giorgi obgaidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currencyTable: UITableView!
    
    var dataManager = DataManager()
    var givenData: [CurrencyRate] = []
    let myLoader = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyTable.delegate = self
        currencyTable.dataSource = self
        dataManager.delegate = self
        createLoadView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.dataManager.getCurrencyData()
        })
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        currencyTable.register(nib, forCellReuseIdentifier: "customCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh(_ :)), for: .valueChanged)
        currencyTable.refreshControl = refreshControl
            
    }
    
    @objc func refresh(_ sender: Any){
        dataManager.getCurrencyData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.currencyTable.refreshControl?.endRefreshing()
        }
    }
    
    func getLabelWithImage(_ index: Int, _ label: String) -> NSMutableAttributedString{
        let fullString = NSMutableAttributedString(string: label)
        let iconAttachment = NSTextAttachment()
        let iconSize = CGRect(x: 2, y: -2, width: 10, height: 10)
        iconAttachment.image = givenData[index].image
        iconAttachment.bounds = iconSize
        
        fullString.append(NSAttributedString(attachment: iconAttachment))
        return fullString
    }
    
    func createLoadView(){
        addChild(myLoader)
        
        myLoader.view.frame = view.frame
        view.addSubview(myLoader.view)
        myLoader.didMove(toParent: self)
    }

}


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return tableView.frame.height/2
        }else{
            return tableView.frame.height/4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return tableView.frame.height/6
        }else{
            return tableView.frame.height/12
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.text = "Today's Currency Rate"
        headerLabel.backgroundColor = .orange
        headerLabel.textAlignment = NSTextAlignment.center
        return headerLabel
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        givenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        
        if givenData.count != 0{
            let index = indexPath.row
            cell.currancyShortName.text = givenData[index].shortName
            cell.currancyFullname.text = givenData[index].fullName
            cell.courseValue.text = givenData[index].cource
            cell.changeValue.attributedText = getLabelWithImage(index, givenData[index].change)
        }
        
        return cell
    }
    
    
}

extension ViewController: DataManagerDelegate{
    func updateTable(_ currencyData: [CurrencyRate]) {
        givenData = currencyData
        currencyTable.reloadData()
        myLoader.willMove(toParent: nil)
        myLoader.view.removeFromSuperview()
        myLoader.removeFromParent()
    }
    
    
}

