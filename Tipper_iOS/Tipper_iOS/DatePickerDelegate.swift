//
//  datePickerDelegate.swift
//  Tipper_iOS
//
//  Created by גיל אושר on 27.12.2015.
//  Copyright © 2015 gil osher. All rights reserved.
//

import UIKit

class DatePickerDelegate:NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectedMonth: Int!;
    var selectedYear: Int!;
    let monthNames = ["ינואר", "פברואר", "מרץ", "אפריל", "מאי", "יוני", "יולי", "אוגוסט", "ספטמבר", "אוקטובר", "נובמבר" ,"דצמבר"];
    let today: NSDate;
        
    override init() {
        today = NSDate();
        selectedMonth = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: today) - 1;
        selectedYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: today);
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12;
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let todayYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: today);
        if component == 0{
            selectedYear = row + todayYear;
            print("\(selectedYear)");
        }else{
            selectedMonth = row;
            print("\(selectedMonth)");
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let todayYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: today);
        if component == 0{
            return "\(todayYear + row)"
        }else{
            return monthNames[row];
        }
        
    }
}