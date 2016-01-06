//
//  SettingsViewController.swift
//  Tiper_iOS
//
//  Created by גיל אושר on 23.12.2015.
//  Copyright © 2015 gil osher. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    var statusBar: UIView!;
    var btnSave: UIButton!;
    var txtSalaryPerHour: UITextField!;
    var lblSalaryPerHour: UILabel!;
    var switchSounds: UISwitch!;
    var lblSounds: UILabel!;
    var navBar: UINavigationBar!;
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(netHex: 0x2979FF);
        
        statusBar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: UIApplication.sharedApplication().statusBarFrame.height));
        statusBar.backgroundColor = UIColor(netHex: 0x1F2839);
        view.addSubview(statusBar);
        
        view.backgroundColor = UIColor(netHex: 0x90CAF9);
        navBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.sharedApplication().statusBarFrame.height, width: view.frame.width, height: 40))
        let navItem = UINavigationItem(title: "הגדרות");
        navItem.leftBarButtonItem = UIBarButtonItem(title: "חזור", style: UIBarButtonItemStyle.Done, target: self, action: "backToHome");
        navBar.items = [navItem];
        view.addSubview(navBar);
        let prefrences = NSUserDefaults.standardUserDefaults();
        let salary = prefrences.objectForKey("salary_per_hour");
        txtSalaryPerHour = UITextField(frame: CGRect(x: 15, y: navBar.frame.maxY + 20, width: 100, height: 40))
        txtSalaryPerHour.delegate = self;
        if let theSalary = salary{
            txtSalaryPerHour.text = "\(theSalary)";
        }else{
            txtSalaryPerHour.text = "0";
        }
        txtSalaryPerHour.borderStyle = .RoundedRect;
        txtSalaryPerHour.alpha = 0.5;
        txtSalaryPerHour.textAlignment = .Center;
        txtSalaryPerHour.keyboardType = .DecimalPad;
        addDoneButtonToKeyboard();
        view.addSubview(txtSalaryPerHour);
        let lblSheqel = UILabel(frame: CGRect(x: txtSalaryPerHour.frame.maxX + 5, y: navBar.frame.maxY + 25, width: 20, height: 40))
        lblSheqel.text = "₪";
        lblSheqel.textAlignment = .Left;
        view.addSubview(lblSheqel);
        lblSalaryPerHour = UILabel(frame: CGRect(x: view.frame.width - 100 - 15, y: navBar.frame.maxY + 20, width: 100, height: 40))
        lblSalaryPerHour.textAlignment = .Right;
        lblSalaryPerHour.font = UIFont.boldSystemFontOfSize(18);
        lblSalaryPerHour.text = "שכר לשעה";
        view.addSubview(lblSalaryPerHour);
        
        switchSounds = UISwitch(frame: CGRect(x: 30, y: txtSalaryPerHour.frame.maxY + 25, width: 50, height: 50));
        switchSounds.onTintColor = UIColor(netHex: 0xFFC107);
        if let soundsAllowed = prefrences.objectForKey("sounds") as? Bool{
            switchSounds.on = soundsAllowed;
        }else{
            switchSounds.on = true;
        }
        view.addSubview(switchSounds);
        
        lblSounds = UILabel(frame: CGRect(x: view.frame.width - 150 - 15, y: txtSalaryPerHour.frame.maxY + 20, width: 150, height: 40))
        lblSounds.textAlignment = .Right;
        lblSounds.font = UIFont.boldSystemFontOfSize(18);
        lblSounds.text = "צלילים באפליקציה";
        view.addSubview(lblSounds);
        
        btnSave = UIButton(type: UIButtonType.System);
        btnSave.frame = CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50);
        btnSave.setTitle("שמור שינויים", forState: UIControlState.Normal);
        btnSave.backgroundColor = UIColor(netHex: 0xFFC107);
        btnSave.tintColor = UIColor.blackColor();
        btnSave.titleLabel!.font = UIFont.boldSystemFontOfSize(18);
        btnSave.addTarget(self, action: "saveSettings:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btnSave);
    }
    
    func saveSettings(sender: UIButton){
        let salary = txtSalaryPerHour.text! as NSString;
        if(!SettingsViewController.checkNumberString(salary)){
            let invalidController = UIAlertController(title: "שגיאה", message: "אנא וודא שהכנסת מספר עשרוני תקין", preferredStyle: UIAlertControllerStyle.Alert);
            invalidController.addAction(UIAlertAction(title: "אישור", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                
            }))
            presentViewController(invalidController, animated: true, completion: nil);
            return;
        }
        let preferences = NSUserDefaults.standardUserDefaults();
        preferences.setBool(switchSounds.on, forKey: "sounds");
        preferences.setFloat(Float(salary as String)!, forKey: "salary_per_hour");
        preferences.synchronize();
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    static func checkNumberString(str: NSString)->Bool{
        if str.length == 0{
            return false;
        }
        var thereIsPoint = false;
        for i in 0..<(str as NSString).length{
            let asciiNum = Int(str.characterAtIndex(i));
            if(asciiNum < 48 || asciiNum > 57){
                if(asciiNum == 46){
                    if(thereIsPoint || i==0 || i == str.length-1){
                        return false;
                    }else{
                        thereIsPoint = true;
                    }
                }else{
                    return false;
                }
            }
        }
        return true;
    }
    
    func backToHome(){
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func addDoneButtonToKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.width, 30));
        doneToolbar.barStyle = .Default;
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("keyboardDoneButtonPressed"));
        
        var items = [UIBarButtonItem]();
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items;
        doneToolbar.sizeToFit()
        
        txtSalaryPerHour.inputAccessoryView = doneToolbar;
        
    }
    
    func keyboardDoneButtonPressed(){
        txtSalaryPerHour.resignFirstResponder();
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
}
