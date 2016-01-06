//
//  TableCellTableViewCell.swift
//  Tipper_iOS
//
//  Created by גיל אושר on 6.1.2016.
//  Copyright © 2016 gil osher. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTimes: UILabel!
    @IBOutlet var lblSumOfHours: UILabel!
    @IBOutlet var lblAverageSalaryPerHour: UILabel!
    @IBOutlet var lblTipsCount: UILabel!
    @IBOutlet var lblSalary: UILabel!
    @IBOutlet var lblSummary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
