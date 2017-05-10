//
//  TrackingModel.swift
//  GasPal
//
//  Created by Kumawat, Diwakar on 4/28/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Parse

enum TrackingTimelineFilter: String {
    case lastWeek = "Last week"
    case lastMonth = "Last month"
    case lastYear = "Last year"
    case allTime = "All time"
}

class TrackingModel: NSObject {
    
    static let className = String(describing: TrackingModel.self)
    
    var pfObject = PFObject(className: TrackingModel.className)
    
    init(pfObject: PFObject) {
        self.pfObject = pfObject
    }
    
    override init() {
        super.init()
    }
    
    init(date: String, totalAmount: String, pricePerGallon: String) {
        super.init()
        self.date = Date()
        self.totalPrice = 0
        self.unitPrice = 0
        self.gallons = 0
        
        // parse into typed attributes
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        if let dateParsed = dateFormatter.date(from: date) {
            self.date = dateParsed
        }
        if let totalPrice = Double(totalAmount) {
            self.totalPrice = totalPrice
        }
        if let unitPrice = Double(pricePerGallon) {
            self.unitPrice = unitPrice
        }
        if self.unitPrice! > 0 {
            self.gallons = self.totalPrice! / self.unitPrice!
        }
    }
    
    var id: String? {
        get { return pfObject.objectId }
        set { pfObject.objectId = id }
    }
    
    var vehicleId: String? {
        get { return pfObject["vehicleId"] as? String }
        set { pfObject["vehicleId"] = newValue }
    }
    
    var userId: String? {
        get { return pfObject["userId"] as? String }
        set { pfObject["userId"] = newValue }
    }
    
    var date: Date? {
        get { return pfObject["date"] as? Date }
        set { pfObject["date"] = newValue }
    }
    
    var gallons: Double? {
        get { return pfObject["gallons"] as? Double }
        set { pfObject["gallons"] = newValue }
    }
    
    var unitPrice: Double? {
        get { return pfObject["unitPrice"] as? Double }
        set { pfObject["unitPrice"] = newValue }
    }
    
    var totalPrice: Double? {
        get { return pfObject["totalPrice"] as? Double }
        set { pfObject["totalPrice"] = newValue }
    }
    
    var odometerStart: Int? {
        get { return pfObject["odometerStart"] as? Int }
        set { pfObject["odometerStart"] = newValue }
    }
    
    var odometerEnd: Int? {
        get { return pfObject["odometerEnd"] as? Int }
        set { pfObject["odometerEnd"] = newValue }
    }
    
    var mpg: Double? {
        get { return pfObject["mpg"] as? Double }
        set { pfObject["mpg"] = newValue }
    }
    
    static var hasLoadedTracking: Bool! = false
    
    private static var _trackingLogs: [TrackingModel] = []
    static func toArray (objects: [PFObject]?) -> ([TrackingModel]) {
        var items = [TrackingModel]()
        if let objects = objects {
            for pfObject in objects {
                items.append(TrackingModel(pfObject: pfObject))
            }
        }
        _trackingLogs = items
        hasLoadedTracking = true
        return items
    }
    
    static func getAllByVehicle(vehicle: VehicleModel) -> [TrackingModel] {
        var results = [TrackingModel]()
        
        for log in _trackingLogs {
            if log.vehicleId == vehicle.id {
                results.append(log)
            }
        }
        
        return results
    }
    
    func calculate() {
        let gallons = self.gallons ?? 0
        let unitPrice = self.unitPrice ?? 0
        self.totalPrice = Double(round(100 * gallons * unitPrice)/100)
        
        if let odometerStart = odometerStart,
            let odometerEnd = odometerEnd {
            let mpg = Double(odometerEnd - odometerStart) / gallons
            self.mpg = Double(round(mpg * 10)/10)
        }
    }
    
    static func getAllByTimelineAndVehicle(timelineFilter: TrackingTimelineFilter, vehicle: VehicleModel) -> [TrackingModel] {
        
        var results = [TrackingModel]()
        
        let calendar = Calendar.current
        var beginDate: Date!
        let endDate: Date! = Date()
        
        switch timelineFilter {
        case .lastWeek:
            beginDate = calendar.date(byAdding: .day, value: -7, to: endDate)
        case .lastMonth:
            beginDate = calendar.date(byAdding: .month, value: -1, to: endDate)
        case .lastYear:
            beginDate = calendar.date(byAdding: .year, value: -1, to: endDate)
        case .allTime:
            for log in _trackingLogs {
                if log.vehicleId == vehicle.id {
                    results.append(log)
                }
            }
            return results
        }
        
        for log in _trackingLogs {
            if log.date! > beginDate && log.vehicleId == vehicle.id {
                results.append(log)
            }
        }
        
        return results
        
    }
}
