//
//  SecondViewController.swift
//  Tiper_iOS
//
//  Created by גיל אושר on 22.12.2015.
//  Copyright © 2015 gil osher. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    var allShifts: [Shift]!;
    var navBar: UINavigationBar!;
    var datePicker: UIPickerView!;
    var shiftTable: UITableView!;
    var tableDetailsView: UIView!;
    var lblTotalSummary: UILabel!;
    var lblTotalSalary: UILabel!;
    var lblTotalTips: UILabel!;
    var lblAverageSalaryPerHour: UILabel!;
    var totalSummary: Float!;
    var totalSalary: Float!;
    var totalTips: Int!;
    var tabBarHeight: CGFloat!;
    var averageSalaryPerHour: Float!;

    //delegate fields
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var selectedMonth: Int!;
    var selectedYear: Int!;
    let monthNames = ["ינואר", "פברואר", "מרץ", "אפריל", "מאי", "יוני", "יולי", "אוגוסט", "ספטמבר", "אוקטובר", "נובמבר" ,"דצמבר"];
    var today: NSDate!;
    var currentShifts: [Shift]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //define main view
        view.backgroundColor = UIColor(netHex: 0x2979FF);
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.sharedApplication().statusBarFrame.height));
        statusBar.backgroundColor = UIColor(netHex: 0x1F2839);
        view.addSubview(statusBar);
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        tabBarHeight = (storyBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController).tabBar.frame.size.height;
        navBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.height, width: view.frame.width, height: 40))
        let navItem = UINavigationItem();
        navItem.title = "היסטוריית משמרות";
        navBar.items = [navItem];
        view.addSubview(navBar);
        
        
        //load required fields
        today = NSDate();
        selectedMonth = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: today)-1;
        selectedYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: today);
        totalTips = 0;
        totalSalary = 0;
        totalSummary = 0;
        averageSalaryPerHour = 0;
        allShifts = appDelegate.getShifts();
        currentShifts = [Shift]();
        createViews();
    }
    
    func createViews(){
        datePicker = UIPickerView(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width , height: 50));
        datePicker.delegate = self;
        datePicker.dataSource = self;
        datePicker.backgroundColor = UIColor(netHex: 0xFFC107)
        view.addSubview(datePicker);
        let lblSaperateLine4 = UIView(frame: CGRect(x: datePicker.frame.width / 2, y: datePicker.frame.origin.y, width: 2, height: 50));
        lblSaperateLine4.backgroundColor = UIColor.blackColor();
        view.addSubview(lblSaperateLine4);
        shiftTable = UITableView(frame: CGRect(x: 0, y: datePicker.frame.maxY, width: view.frame.width, height: view.frame.height - datePicker.frame.height - navBar.frame.height - UIApplication.sharedApplication().statusBarFrame.size.height - tabBarHeight - 60));
        shiftTable.backgroundColor = UIColor(netHex: 0x0288D1);
        shiftTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "shift_table");
        shiftTable.delegate = self;
        shiftTable.dataSource = self;
        let nib = UINib(nibName: "viewTableCell", bundle: nil);
        shiftTable.registerNib(nib, forCellReuseIdentifier: "cell");
        view.addSubview(shiftTable);
        tableDetailsView = UIView(frame: CGRect(x: 0, y: shiftTable.frame.maxY, width: view.frame.width, height: 60))
        tableDetailsView.backgroundColor = UIColor(netHex: 0xFFC107);
        lblTotalSummary = UILabel(frame: CGRect(x: 0, y: 0, width: tableDetailsView.frame.width/3, height: 30));
        lblTotalSummary.textAlignment = .Center
        lblTotalSummary.font = UIFont(name: lblTotalSummary.font.fontName, size: 14);
        tableDetailsView.addSubview(lblTotalSummary);
        let lblSaperateLine1 = UIView(frame: CGRect(x: lblTotalSummary.frame.maxX, y: 0, width: 2, height: 30));
        lblSaperateLine1.backgroundColor = UIColor.blackColor();
        tableDetailsView.addSubview(lblSaperateLine1);
        lblTotalSalary = UILabel(frame: CGRect(x: lblTotalSummary.frame.maxX, y: 0, width: tableDetailsView.frame.width/3 + 10, height: 30));
        lblTotalSalary.textAlignment = .Center
        lblTotalSalary.font = UIFont(name: lblTotalSalary.font.fontName, size: 14);
        tableDetailsView.addSubview(lblTotalSalary);
        let lblSaperateLine2 = UIView(frame: CGRect(x: lblTotalSalary.frame.maxX, y: 0, width: 2, height: 30));
        lblSaperateLine2.backgroundColor = UIColor.blackColor();
        tableDetailsView.addSubview(lblSaperateLine2);
        lblTotalTips = UILabel(frame: CGRect(x: lblTotalSalary.frame.maxX, y: 0, width: tableDetailsView.frame.width/3 - 10, height: 30));
        lblTotalTips.textAlignment = .Center
        lblTotalTips.font = UIFont(name: lblTotalTips.font.fontName, size: 14);
        tableDetailsView.addSubview(lblTotalTips);
        let lblSaperateLine3 = UIView(frame: CGRect(x: 0, y: lblTotalTips.frame.maxY, width: tableDetailsView.frame.width, height: 2));
        lblSaperateLine3.backgroundColor = UIColor.blackColor();
        tableDetailsView.addSubview(lblSaperateLine3);
        lblAverageSalaryPerHour = UILabel(frame: CGRect(x: 0, y: lblTotalSummary.frame.maxY, width: view.frame.width, height: 30))
        lblAverageSalaryPerHour.textAlignment = .Center;
        lblAverageSalaryPerHour.font = UIFont.boldSystemFontOfSize(16);
        tableDetailsView.addSubview(lblAverageSalaryPerHour);
        view.addSubview(tableDetailsView);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        shiftTable.resignFirstResponder();
        datePicker.selectRow(selectedYear, inComponent: 0, animated: true);
        datePicker.selectRow(selectedMonth, inComponent: 1, animated: true);
        allShifts = appDelegate.getShifts();
        print("number of shift: \(allShifts.count)");
        for i in 0..<allShifts.count{
            print("\(allShifts[i].id)");
        }
        notifyShiftTable();
        shiftTable.reloadData();
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12;
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            let todayYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: today);
            selectedYear = row + todayYear;
        }else{
            selectedMonth = row;
        }
        notifyShiftTable();
        shiftTable.reloadData();
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            let todayYear = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: today);
            return "\(todayYear + row)"
        }else{
            return monthNames[row];
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentShifts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // create custom TableViewCell
        let cell:TableViewCell = shiftTable.dequeueReusableCellWithIdentifier("cell") as! TableViewCell;
        let shift = allShifts[indexPath.row];
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 2
        cell.lblDate.text = "\(Shift.getDate(shift.startTime))";
        cell.lblTimes.text = "\(Shift.getHourString(shift.startTime))-\(Shift.getHourString(shift.endTime))";
        cell.lblSumOfHours.text = "שעות: \(shift.getSumOfHoursString())";
        cell.lblTipsCount.text = "טיפים: \(shift.tipsCount)";
        cell.lblSalary.text = "שכר: \(fmt.stringFromNumber(shift.salary)!)";
        cell.lblSummary.text = "סה״כ \(fmt.stringFromNumber(shift.summary)!)";
        fmt.maximumFractionDigits = 0;
        cell.lblAverageSalaryPerHour.text = "שכר ממוצע לשעה: \(fmt.stringFromNumber(shift.averageSalaryPerHour)!)";
        cell.lblAverageSalaryPerHour.font = UIFont.boldSystemFontOfSize(16);
        
        cell.lblTimes.textColor = UIColor.whiteColor();
        cell.lblDate.textColor = UIColor.whiteColor();
        cell.lblSumOfHours.textColor = UIColor.whiteColor();
        cell.lblTipsCount.textColor = UIColor.whiteColor();
        cell.lblSalary.textColor = UIColor.whiteColor();
        cell.lblSummary.textColor = UIColor.whiteColor();
        cell.lblAverageSalaryPerHour.textColor = UIColor.whiteColor();
        cell.backgroundColor = UIColor(netHex: 0x0288D1);
        cell.textLabel!.textColor = UIColor.whiteColor();
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75;
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let shiftId = currentShifts[indexPath.row].id;
        let shiftDeleted = appDelegate.deleteFromDb(shiftId);
        print("\(shiftDeleted)")
        allShifts = appDelegate.getShifts();
        notifyShiftTable();
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left);
        shiftTable.reloadData();
    }
    
    
    func notifyShiftTable(){
        //reset all fields
        currentShifts.removeAll();
        totalTips = 0;
        totalSalary = 0;
        totalSummary = 0;
        averageSalaryPerHour = 0;
        for i in 0..<allShifts.count{
            let shiftToCheck = allShifts[i];
            let month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: shiftToCheck.startTime)-1; //month from 0 to 11
            let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: shiftToCheck.startTime);
            if month == selectedMonth && year == selectedYear{
                currentShifts.append(shiftToCheck);
                totalTips! += shiftToCheck.tipsCount;
                totalSalary! += shiftToCheck.salary;
                averageSalaryPerHour! += shiftToCheck.averageSalaryPerHour;
            }
        }
        if currentShifts.count > 1 {
            averageSalaryPerHour! /= Float(currentShifts.count);
        }
        totalSummary = Float(totalTips) + totalSalary;
        
        //present all fields
        let fmt = NSNumberFormatter()
        fmt.maximumFractionDigits = 2;
        lblTotalTips.text = "טיפים: \(fmt.stringFromNumber(totalTips)!)₪";
        lblTotalSalary.text = "שכר: \(fmt.stringFromNumber(totalSalary)!)₪";
        lblTotalSummary.text = "סה״כ: \(fmt.stringFromNumber(totalSummary)!)₪";
        fmt.maximumFractionDigits = 0;
        lblAverageSalaryPerHour.text = "שכר ממוצע לשעה: \(fmt.stringFromNumber(averageSalaryPerHour)!)₪";
    }
    
}

