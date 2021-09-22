//
//  MeteorDetailVC.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit
import MapKit

class MeteorDetailVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    var meteor: MeteorElement?
    var isFavorite: Bool = false
    
    static func instanceVC() -> MeteorDetailVC {
        return MeteorDetailVC.instatiateFromStoryBoard(appStoryboard: AppStoryboard.main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.getMeteor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showMeteorOnMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func showData(_ meteor: MeteorElement) {
        self.lblTitle.text = meteor.name
        
        isFavorite = meteor.isFavorite ?? false
        self.btnFavorite.setImage(isFavorite ? UIImage(named: "favorite_green") : UIImage(named: "tab_favorite"), for: .normal)
    }
    
    private func getMeteor() {
        
        guard let meteor = self.meteor else {
            return
        }
        
        let meteorStorage = MeteorStorage.init()
        if let value = meteorStorage.getMeteor(meteor.id) {
            self.meteor = value
            self.showData(value)
        } else {
            fatalError()
        }
    }
    
    private func makeFavorite() {
        
        guard let meteor = self.meteor else {
            return
        }
        
        isFavorite = !isFavorite
        let meteorStorage = MeteorStorage.init()
        meteorStorage.update(meteor.id, isFavorite: isFavorite)
        
        self.getMeteor()
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFavoriteClicked(_ sender: UIButton) {
        self.makeFavorite()
    }
    
    fileprivate func showMeteorOnMap() {
        
        guard  let coordinate = self.meteor?.geolocation else {
            return
        }
        
        let position = CLLocationCoordinate2D.init(latitude: Double(coordinate.latitude)!, longitude: Double(coordinate.longitude)!)
        
        self.mapView.setCenter(position, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = position
        self.mapView.addAnnotation(annotation)
    }
}
