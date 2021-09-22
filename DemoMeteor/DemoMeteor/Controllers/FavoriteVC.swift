//
//  FavoriteVC.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit

class FavoriteVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var viewBlank: UIView!
    
    lazy var meteorList: MeteorListView = {
        let viewObj: MeteorListView = UIView.fromXib()
        return MeteorListView.fromXib()
    }()

    static func instanceVC() -> FavoriteVC {
        return FavoriteVC.instatiateFromStoryBoard(appStoryboard: AppStoryboard.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        self.lblTitle.text = "Favorite"
        
        self.addTableData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showData()
    }
    
    fileprivate func showData() {
        let meteorStorage = MeteorStorage.init()

        self.meteorList.meteorRef = meteorStorage.getMeteors(true)
        
        if self.meteorList.meteorRef.count > 0 {
            self.viewList.isHidden = false
            self.viewBlank.isHidden = true
        } else {
            self.viewList.isHidden = true
            self.viewBlank.isHidden = false
        }
    }
    
    public func addTableData() {
        self.meteorList.frame = CGRect.init(origin: CGPoint.zero, size: self.viewList.frame.size)
        self.meteorList.delegate = self
        self.meteorList.loadData()
        self.viewList.addSubview(self.meteorList)
    }
    

}
extension FavoriteVC: MeteorListDelegate {
    func selectedMeteor(_ index: Int, meteor: MeteorElement) {
        let viewObj = MeteorDetailVC.instanceVC()
        viewObj.meteor = meteor
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewObj, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
