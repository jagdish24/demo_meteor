//
//  MeteorVC.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit

class MeteorVC: UIViewController {
    
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var viewModel = MeteorViewModel.shared
    
    lazy var meteorList: MeteorListView = {
        let viewObj: MeteorListView = UIView.fromXib()
        return MeteorListView.fromXib()
    }()
    
    static func instanceVC() -> MeteorVC {
        return MeteorVC.instatiateFromStoryBoard(appStoryboard: AppStoryboard.main)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        self.lblTitle.text = "Meteor"
        
        self.addTableData()
        self.getMeteorData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public func addTableData() {
        self.meteorList.frame = CGRect.init(origin: CGPoint.zero, size: self.viewList.frame.size)
        self.meteorList.delegate = self
        self.meteorList.loadData()
        self.viewList.addSubview(self.meteorList)
    }
    
    fileprivate func getMeteorData() {
        
        RequestManager.shared.getMeteorData { flag, data, message in
            if flag == true {
                if let values = data {
                    
                    let objects = self.viewModel.byDatefilter(values)
                    
                    let meteorStorage = MeteorStorage.init()
                    meteorStorage.saveMeteors(objects)
                    
                    self.meteorList.meteorRef = meteorStorage.getMeteors()
                }
                self.reloadData()
            }
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.meteorList.tblList.reloadData()
        }
    }
    @IBAction func segmentValueUpdate(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { //by Date
            self.meteorList.meteorRef = self.viewModel.byDatefilter(self.meteorList.meteorRef)
        } else if sender.selectedSegmentIndex == 1 { //by size
            self.meteorList.meteorRef = self.viewModel.bySizefilter(self.meteorList.meteorRef)
        }
    }
}

extension MeteorVC: MeteorListDelegate {
    func selectedMeteor(_ index: Int, meteor: MeteorElement) {
        let viewObj = MeteorDetailVC.instanceVC()
        viewObj.meteor = meteor
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewObj, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
