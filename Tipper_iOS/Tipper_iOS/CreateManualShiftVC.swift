//
//  CreateManualShiftVC.swift
//  Tipper_iOS
//
//  Created by גיל אושר on 5.1.2016.
//  Copyright © 2016 gil osher. All rights reserved.
//

import UIKit

class CreateManualShiftVC: UIViewController, UITextFieldDelegate {
    
    var statusBar: UIView!;
    var navBar: UINavigationBar!;
    var containerView: UIView!;
    var startTimePicker: UIDatePicker!;
    var endTimePicker: UIDatePicker!;
    var txtTipsCount: UITextField!;
    var btnSave: UIButton!;
    var salaryPerHour: Float!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        statusBar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.sharedApplication().statusBarFrame.height));
        statusBar.backgroundColor = UIColor(netHex: 0x1F2839);
        view.addSubview(statusBar);
        
        view.backgroundColor = UIColor(netHex: 0x90CAF9);
        navBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.height, width: view.frame.width, height: 40))
        let navItem = UINavigationItem();
        navItem.title = "הוספת משמרת ידנית";
        navItem.leftBarButtonItem = UIBarButtonItem(title: "חזור", style: UIBarButtonItemStyle.Done, target: self, action: "backToMain");
        navBar.items = [navItem];
        view.addSubview(navBar);
        //get the user salaryPerHour
        let prefrences = NSUserDefaults.standardUserDefaults();
        let salary = prefrences.objectForKey("salary_per_hour");
        if let theSalary = salary{
            salaryPerHour = theSalary as! Float;
        }else{
            salaryPerHour = 25;
        }
        createMainView();
    }
    
    func createMainView(){
        containerView = UIView(frame: CGRect(x: 0, y: navBar.frame.maxY, width: view.frame.width, height: view.frame.height - navBar.frame.height - statusBar.frame.height - 50));
        let lblStartTime = UILabel(frame: CGRect(x: 10, y: 10, width: containerView.frame.width - 20, height: 30));
        lblStartTime.text = "שעת התחלה";
        lblStartTime.textAlignment = .Center;
        lblStartTime.font = UIFont.boldSystemFontOfSize(18);
        containerView.addSubview(lblStartTime);
        startTimePicker = UIDatePicker(frame: CGRect(x: 10, y: lblStartTime.frame.maxY, width: containerView.frame.width - 20, height: 50));
        startTimePicker.date = NSDate();
        containerView.addSubview(startTimePicker);
        let lblEndTime = UILabel(frame: CGRect(x: 10, y: startTimePicker.frame.maxY, width: containerView.frame.width - 20, height: 30));
        lblEndTime.text = "שעת סיום";
        lblEndTime.textAlignment = .Center;
        lblEndTime.font = UIFont.boldSystemFontOfSize(18);
        containerView.addSubview(lblEndTime);
        endTimePicker = UIDatePicker(frame: CGRect(x: 10, y: lblEndTime.frame.maxY, width: containerView.frame.width - 20, height: 50));
        endTimePicker.date = NSDate();
        containerView.addSubview(endTimePicker);
        let lblTipsCount = UILabel(frame: CGRect(x: 10, y: endTimePicker.frame.maxY, width: containerView.frame.width - 20, height: 30));
        lblTipsCount.text = "טיפים";
        lblTipsCount.textAlignment = .Center;
        lblTipsCount.font = UIFont.boldSystemFontOfSize(18);
        containerView.addSubview(lblTipsCount);
        txtTipsCount = UITextField(frame: CGRect(x: (containerView.frame.width - 80) / 2, y: lblTipsCount.frame.maxY + 10, width: 80, height: 30));
        txtTipsCount.borderStyle = .RoundedRect;
        txtTipsCount.delegate = self;
        txtTipsCount.keyboardType = .NumberPad;
        txtTipsCount.textAlignment = .Center;
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.width, 30));
        doneToolbar.barStyle = .Default;
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("keyboardDoneButtonPressed"));
        var items = [UIBarButtonItem]();
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items;
        doneToolbar.sizeToFit()
        txtTipsCount.inputAccessoryView = doneToolbar;
        txtTipsCount.backgroundColor = UIColor(netHex: 0xF5F5F5);
        containerView.addSubview(txtTipsCount);
        btnSave = UIButton(type: UIButtonType.System);
        btnSave.frame = CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50);
        btnSave.setTitle("שמור", forState: UIControlState.Normal);
        btnSave.addTarget(self, action: "createShift", forControlEvents: UIControlEvents.TouchUpInside);
        btnSave.backgroundColor = UIColor(netHex: 0xFFC107);
        btnSave.tintColor = UIColor.blackColor();
        btnSave.titleLabel!.font = UIFont.boldSystemFontOfSize(18);
        btnSave.addTarget(self, action: "backToMain", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btnSave);
        view.addSubview(containerView);
    }
    
    func backToMain(){
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func createShift(){
        let tips = txtTipsCount.text;
        if let theTips = tips{
            if !CreateManualShiftVC.validNumber(theTips){
                let invalidController = UIAlertController(title: "שגיאה", message: "אנא וודא שהכנסת מספר תקין", preferredStyle: UIAlertControllerStyle.Alert);
                invalidController.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                    }))
                presentViewController(invalidController, animated: true, completion: nil);
                return;
            }
            let tipsCount = Int(theTips)!;
            addShiftToDB(startTimePicker.date, endTime: endTimePicker.date, salaryPerHour: salaryPerHour, tipsCount: tipsCount);
            dismissViewControllerAnimated(true, completion: nil);
        }
        
    }
    
    func addShiftToDB(startTime: NSDate, endTime: NSDate, salaryPerHour: Float, tipsCount: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        appDelegate.insertToDB(startTime, endTime: endTime, salaryPerHour: salaryPerHour, tipsCount: tipsCount);
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func keyboardDoneButtonPressed(){
        txtTipsCount.resignFirstResponder();
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    static func validNumber(str: NSString)-> Bool{
        for i in 0..<(str as NSString).length{
            let asciiNum = Int(str.characterAtIndex(i));
            if(asciiNum < 48 || asciiNum > 57){
                return false;
            }
        }
        return true;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
}