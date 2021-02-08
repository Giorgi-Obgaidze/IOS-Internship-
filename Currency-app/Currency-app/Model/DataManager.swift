//
//  DataManager.swift
//  Currency-app
//
//  Created by giorgi obgaidze on 2/7/21.
//  Copyright © 2021 giorgi obgaidze. All rights reserved.
//

import Foundation
import UIKit
import Kanna


protocol DataManagerDelegate {
    func updateTable(_ currencyData: [CurrencyRate])
}


class CurrencyRate{
    var fullName = ""
    var shortName = ""
    var cource = ""
    var change = ""
    var image = UIImage()
    
}

class DataManager: NSObject{
    var xmlUrl = "http://www.nbg.ge/rss.php"
    var currencies : [CurrencyRate] = []
    var imgURLs : [String] = []
    var currentData: CurrencyRate?
    var group = DispatchGroup()
    
    var delegate: DataManagerDelegate?
    
    
    
    func getCurrencyData() {
        if let url = URL(string: xmlUrl){
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else{
                    print(error ?? "unknown error")
                    return
                }
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
            task.resume()
        }
    }
    
    func downloadImages() {
        for i in 0...imgURLs.count - 1{
            group.enter()
            let url = URL(string: imgURLs[i])!
            let dataTask = URLSession.shared.dataTask(with: url) {(data, _, _) in
                if let myData = data{
                    self.currencies[i].image = UIImage(data: myData)!
                    self.group.leave()
                }
            }
        dataTask.resume()
        }
        
    }
}


extension DataManager: XMLParserDelegate{
    
    func assignData(_ html: String?){
        if let doc = try? Kanna.HTML(html: html!, encoding: String.Encoding.utf8) {
            currentData = CurrencyRate()
            var count = 0
            for td in doc.css("td") {
                if count == 5 {
                    currencies.append(currentData!)
                    currentData = CurrencyRate()
                    count = 0
                }
                if count == 0{
                    currentData!.shortName = td.text!
                    count += 1
                }else if count == 1{
                    currentData!.fullName = td.text!
                    count += 1
                }else if count == 2{
                    currentData!.cource = td.text!
                    count += 1
                }else if count == 3{
                    imgURLs.append(doc.css("img, src")[0]["src"]!)
                    count += 1
                }else{
                    currentData!.change = td.text!
                    count += 1
                }
            }
            currencies.append(currentData!)
            downloadImages()
            group.notify(queue: DispatchQueue.main){
                self.delegate?.updateTable(self.currencies)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        let s = String(data: CDATABlock, encoding: .utf8)
        assignData(s)
    }
    
}
