//
//  Shift.swift
//  Tiper_iOS
//
//  Created by גיל אושר on 27.12.2015.
//  Copyright © 2015 gil osher. All rights reserved.
//

import Foundation
import CoreData

@objc(Shift)
class Shift: NSManagedObject {
    
    @NSManaged var id: Int;
    @NSManaged var startTime: NSDate;
    @NSManaged var endTime: NSDate;
    @NSManaged var salaryPerHour: Float;
    @NSManaged var tipsCount: Int;
    
    var _id: Int{
        get{
            return self.id;
        }set{
            self.id = newValue;
        }
    }
    
    var _startTime: NSDate{
        get{
            return self.startTime;
        }set{
            self.startTime = newValue;
        }
    }
    
    var _endTime: NSDate{
        get{
            return self.endTime;
        }set{
            self.endTime = newValue;
        }
    }
    
    var _salaryPerHour: Float{
        get{
            return self.salaryPerHour;
        }set{
            self.salaryPerHour = newValue;
        }
    }
    
    var _tipsCount: Int{
        get{
            return self.tipsCount;
        }set{
            self.tipsCount = newValue;
        }
    }
    
    var salary: Float{
        get{
            return getSumOfHours() * salaryPerHour;
        }
    }
    
    var summary: Float{
        get{
            return salary + Float(tipsCount);
        }
    }
    
    var averageSalaryPerHour: Float{
        get{
            return getSumOfHours() > 1 ? (summary == 0 ? 0 : summary / getSumOfHours()) : 0;
        }
    }
    
    static func distanceOfMinutes(startTime: Double, endTime: Double)->Int{
        let distance = startTime.distanceTo(endTime) / 60;
        if distance < 0 {
            return distanceOfMinutes(startTime, endTime: endTime + 24 * 60 * 60 * 1000);
        }
        return Int(distance);
    }
    
    func getSumOfHours()-> Float{
        let distance = Shift.distanceOfMinutes(startTime.timeIntervalSince1970, endTime: endTime.timeIntervalSince1970);
        let numberOfHours = distance / 60;
        let numberOfMinutes = distance % 60;
        return Float(numberOfMinutes)/60 + Float(numberOfHours);
    }
    
    func getSumOfHoursString()-> String{
        let distance = Shift.distanceOfMinutes(startTime.timeIntervalSince1970, endTime: endTime.timeIntervalSince1970);
        let numberOfHours = distance / 60;
        let numberOfMinutes = distance % 60;
        return Shift.getHourString(numberOfHours, minutes: numberOfMinutes);
    }
    
    static func getHourString(hours: Int, minutes: Int)-> String{
        var hoursString = String(hours)
        var minutesString = String(minutes);
        if hours < 10{
            hoursString = "0\(hoursString)"
        }
        if minutes < 10{
            minutesString = "0\(minutesString)"
        }
        return "\(hoursString):\(minutesString)";
    }
    
    static func getHourString(date: NSDate)->String{
        let hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: date);
        let minutes = NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: date);
        return Shift.getHourString(hour, minutes: minutes);
    }
    
    static func getDate(date: NSDate)->String{
        let dayOfMonth = NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: date);
        var dayOfMonthString = String(dayOfMonth);
        if dayOfMonth < 10{
            dayOfMonthString = "0\(dayOfMonthString)"
        }
        let month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: date);
        var monthString = String(month);
        if month < 10{
            monthString = "0\(monthString)"
        }
        return "\(dayOfMonthString)/\(monthString)";
    }
    
}