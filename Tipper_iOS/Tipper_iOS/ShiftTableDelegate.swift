//
//  shiftTableDelegate.swift
//  Tipper_iOS
//
//  Created by גיל אושר on 27.12.2015.
//  Copyright © 2015 gil osher. All rights reserved.
//

import UIKit

class ShiftTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var allShifts: [Shift]!;
    
    init(shifts: [Shift]) {
        super.init();
        allShifts = shifts;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allShifts.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("shift_table", forIndexPath: indexPath);
        cell.textLabel!.text = "\(allShifts[indexPath.row].id)";
        cell.backgroundColor = UIColor(netHex: 0x0288D1);
        cell.textLabel!.textColor = UIColor.whiteColor();
        return cell;
    }
}
