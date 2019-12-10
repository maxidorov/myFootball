//
//  DatePickerTableViewCell.swift
//  myFootball
//
//  Created by Maxim Sidorov on 09.12.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {
    func didChangeDate(date: Date, indexPath: IndexPath)
}

class DatePickerTableViewCell: UITableViewCell {
    
    let datePicker = UIDatePicker()
    
    var indexPath: IndexPath!
    weak var delegate: DatePickerDelegate?
    
    static let reuseIdentifier = "DatePickerTableViewCellIdentifier"
    static let cellHeight: CGFloat = 162.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        setupDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDatePicker() {
        contentView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        datePicker.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func updateCell(date: Date, indexPath: IndexPath) {
        datePicker.setDate(date, animated: true)
        self.indexPath = indexPath
    }
    
    @objc
    func dateDidChange(_ sender: UIDatePicker) {
        let indexPathForDisplayDate = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        delegate?.didChangeDate(date: sender.date, indexPath: indexPathForDisplayDate)
    }

}
