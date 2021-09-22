//
//  MeteorListView.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit

protocol MeteorListDelegate: NSObject {
    func selectedMeteor(_ index: Int, meteor: MeteorElement)
}

class MeteorListView: UIView {
    
    weak var delegate: MeteorListDelegate?
    
    var meteorRef: [MeteorElement] = [MeteorElement]() {
        didSet {
            DispatchQueue.main.async {
                self.tblList.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tblList: UITableView!
    
    internal func loadData() {
        self.tblList.register(UITableViewCell.self, forCellReuseIdentifier: "MeteorCell")
        self.tblList.delegate = self
        self.tblList.dataSource = self
    }
    
}

extension MeteorListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meteorRef.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MeteorCell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        let meteor = self.meteorRef[indexPath.row]
        
        let show = MeteorViewModel.shared.logicApply(meteor)
        
        cell.textLabel?.text = meteor.name
        cell.detailTextLabel?.text = "\(show.date) \(show.mass)"
        cell.detailTextLabel?.textColor = UIColor(named: "app_lightgray")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedMeteor(indexPath.row, meteor: meteorRef[indexPath.row])
    }
    
}
