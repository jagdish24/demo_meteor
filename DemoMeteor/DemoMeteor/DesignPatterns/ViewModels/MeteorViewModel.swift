//
//  MeteorViewModel.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit

class MeteorViewModel {
    
    static var shared: MeteorViewModel = MeteorViewModel()
    private init() {}

    var aryMeteors = [MeteorElement]()
    
    func logicApply(_ meteor: MeteorElement) -> MeteorShow {
        let date = self.dateFormatToShow(meteor.year ?? "")
        let mass = self.showMass(meteor.mass)
        return MeteorShow.init(date: date, mass: mass.description)
    }
    
    func dateFormatToShow(_ date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
       
        if let dateValue = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let showDate = dateFormatter.string(from: dateValue)
            return showDate
        }
        return ""
    }
    
    func showMass(_ mass: String?) -> Measurement<UnitMass> {
        
        guard let massUnit = mass else {
            return Measurement.init(value: 0, unit: .kilograms)
        }
        
        let gramUnit = UnitMass.grams
        let goodWeight:Measurement = Measurement(value: Double(massUnit)!, unit: gramUnit)
        let kgMass = goodWeight.converted(to: .kilograms)
        return kgMass
    }
    
    internal func byDatefilter(_ objects: [MeteorElement]) -> [MeteorElement] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        let ready = objects.sorted { meteorA, meteorB in
            guard let dateA = dateFormatter.date(from: meteorA.year ?? "") else {
                return false
            }
            guard let dateB = dateFormatter.date(from: meteorB.year ?? "") else {
                return false
            }
            return dateA.compare(dateB) == .orderedDescending
        }
        
        return ready
    }
    
    internal func bySizefilter(_ objects: [MeteorElement]) -> [MeteorElement] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        let ready = objects.sorted { meteorA, meteorB in
            let massA = MeteorViewModel.shared.showMass(meteorA.mass)
            let massB = MeteorViewModel.shared.showMass(meteorB.mass)
            return massA.value > massB.value
        }
        return ready
    }


}


struct MeteorShow {
    var date: String
    var mass: String
    
    init(date: String, mass: String) {
        self.date = date
        self.mass = mass
    }
}
