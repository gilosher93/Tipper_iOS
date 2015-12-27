//
//  SecondViewController.swift
//  Tiper_iOS
//
//  Created by גיל אושר on 22.12.2015.
//  Copyright © 2015 gil osher. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController{
    
    var allShifts: [Shift]!;
    var navBar: UINavigationBar!;
    var datePicker: UIPickerView!;
    var shiftTable: UITableView!;
    var tableDetailsView: UIView!;
    var totalSummary: UILabel!;
    var totalSalary: UILabel!;
    var totalTips: UILabel!;
    var tabBarHeight: CGFloat!;
    var datePickerDelegate: DatePickerDelegate!;
    var shiftTableDelegate: ShiftTableDelegate!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(netHex: 0x2979FF);
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.sharedApplication().statusBarFrame.height));
        statusBar.backgroundColor = UIColor(netHex: 0x1F2839);
        view.addSubview(statusBar);
        let storyBoard = UIStoryboard(name: "Main", bundle: nil);
        tabBarHeight = (storyBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController).tabBar.frame.size.height;
        navBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.height, width: view.frame.width, height: 40))
        let navItem = UINavigationItem();
        navItem.title = "דוחות";
        navItem.leftBarButtonItem = UIBarButtonItem(title: "הגדרות", style: UIBarButtonItemStyle.Plain, target: self, action: "openSettings");
        navBar.items = [navItem];
        view.addSubview(navBar);
        notifyAllShifts();
        datePickerDelegate = DatePickerDelegate();
        shiftTableDelegate = ShiftTableDelegate(shifts: allShifts);
        createViews();
    }
    
    func createViews(){
        datePicker = UIPickerView(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width , height: 50));
        datePicker.delegate = datePickerDelegate;
        datePicker.dataSource = datePickerDelegate;
        datePicker.backgroundColor = UIColor(netHex: 0xFFC107)
        datePicker.selectRow(datePickerDelegate.selectedYear, inComponent: 0, animated: true);
        datePicker.selectRow(datePickerDelegate.selectedMonth, inComponent: 1, animated: true);
        view.addSubview(datePicker);
        shiftTable = UITableView(frame: CGRect(x: 0, y: datePicker.frame.maxY, width: view.frame.width, height: view.frame.height - datePicker.frame.height - navBar.frame.height - UIApplication.sharedApplication().statusBarFrame.size.height - tabBarHeight - 50));
        shiftTable.backgroundColor = UIColor(netHex: 0x0288D1);
        shiftTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "shift_table");
        shiftTable.delegate = shiftTableDelegate;
        shiftTable.dataSource = shiftTableDelegate;
        view.addSubview(shiftTable);
        tableDetailsView = UIView(frame: CGRect(x: 0, y: shiftTable.frame.maxY, width: view.frame.width, height: 50))
        tableDetailsView.backgroundColor = UIColor(netHex: 0xFFC107);
        totalSummary = UILabel(frame: CGRect(x: 0, y: 0, width: tableDetailsView.frame.width/3, height: tableDetailsView.frame.height));
        totalSummary.textAlignment = .Center
        totalSummary.font = UIFont.boldSystemFontOfSize(14);
        tableDetailsView.addSubview(totalSummary);
        totalSalary = UILabel(frame: CGRect(x: totalSummary.frame.maxX, y: 0, width: tableDetailsView.frame.width/3 + 10, height: tableDetailsView.frame.height));
        totalSalary.textAlignment = .Center
        totalSalary.font = UIFont.boldSystemFontOfSize(14);
        tableDetailsView.addSubview(totalSalary);
        totalTips = UILabel(frame: CGRect(x: totalSalary.frame.maxX, y: 0, width: tableDetailsView.frame.width/3 - 10, height: tableDetailsView.frame.height));
        totalTips.textAlignment = .Center
        totalTips.font = UIFont.boldSystemFontOfSize(14);
        tableDetailsView.addSubview(totalTips);
        view.addSubview(tableDetailsView);
    }
    
    func notifyAllShifts(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        allShifts = appDelegate.getShifts();
        print("number of shift: \(allShifts.count)");
    }
    
    func openSettings(){
        presentViewController(SettingsViewController(), animated: true, completion: nil);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

