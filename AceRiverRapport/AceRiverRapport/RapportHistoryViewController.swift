//
//  HistoryVC.swift
//  AceRiverRapport
//
//  Created by jin fu on 2025/3/13.
//


import UIKit

class RapportHistoryViewController: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if arrHistory.isEmpty{
            lbl.isHidden = true
            return
        }
        
        tbl.delegate = self
        tbl.dataSource = self
    }
    
}

extension RapportHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tbl.dequeueReusableCell(withIdentifier: "HelperCell", for: indexPath)as! HelperCell
        let i = arrHistory.reversed()[indexPath.item]
        cell.field.text = "=> \(indexPath.item+1)." + "\n" + "SCORE: \(i.score)" + "\n" + "AT TIME: \(i.time.toString())"
        cell.img.image = UIImage(data: i.img)
        return cell
    }
    
}
