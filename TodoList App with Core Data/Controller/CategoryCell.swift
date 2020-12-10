//
//  CategoryCell.swift
//  TodoList App with Core Data
//
//  Created by Admin on 08/09/20.
//  Copyright © 2020 kodechamp. All rights reserved.
//

import UIKit
 var selectedDate:String = ""
class CategoryCell: UITableViewCell {
    
    var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
 //   var selectedDate:String = ""
 //   var dates:[String] = []
    @IBOutlet var TaskName: UITextField!
    
    @IBOutlet var DateTask: UITextField!
    
    @IBOutlet var IconImage: UIImageView!
    
    @IBOutlet var CircleImg: UIImageView!
    
    @IBOutlet var LikeButton: UIButton!
    
    @IBOutlet var CheckButton: UIButton!
    
  
    
    @IBAction func FavAction(_ sender: UIButton) {
    
          LikeButton.tintColor = UIColor.systemPink
        
      
      }
    
    @IBAction func DoneAction(_ sender: UIButton) {
        
        CheckButton.tintColor = UIColor.green
    }
    
          var isChecked = false
        
        
            //  var datePicker = UIDatePicker()
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
             TaskName.borderStyle = .none
            DateTask.borderStyle = .none
                   DateTask.borderStyle = .none
                 //  datepickerbirth()
                  // doneselect()
            DateTask.inputView = datePicker
                   setupDatePicker()
                
            DateTask.placeholder = "Pick a due date"
            datePicker.datePickerMode = UIDatePicker.Mode.date
           // self.setInputViewDatePicker(target: self, selector: #selector(tapDone))
            
          //  self.setInputViewDatePicker(target: self, selector: #selector(tapCancel))
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
//           button2.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
//             accessoryView = button2
                }
                
            func setupDatePicker() {
                    // Sets up the "button"
                    DateTask.text = "Pick a due date"
                DateTask.textAlignment = .left

                    // Removes the indicator of the UITextField
                DateTask.tintColor = UIColor.clear

                    // Specifies intput type
                datePicker.datePickerMode = .date

                    // Creates the toolbar
                    let toolBar = UIToolbar()
                toolBar.barStyle = .default
                toolBar.isTranslucent = true
                    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
                    toolBar.sizeToFit()

                    // Adds the buttons
                let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: Selector(("doneClick")))
                //_ = UIBarButtonItem(title: "Done", style: .plain, target: self, action: Selector(("doneClick")))
                let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: Selector(("cancelClick")))
                    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
                toolBar.isUserInteractionEnabled = true

                    // Adds the toolbar to the view
                    DateTask.inputView = datePicker
                    DateTask.inputAccessoryView = toolBar
                }

                @objc func doneClick() {
                    let dateFormatter = DateFormatter()
                    //dateFormatter.dateFormat = "dd-MM-yyyy"
                   // dateFormatter.dateStyle = .ShortStyle
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    DateTask.text = dateFormatter.string(from: datePicker.date)
                    DateTask.resignFirstResponder()
                    selectedDate.append(DateTask.text!)
                    print(selectedDate)
                }

                @objc func cancelClick() {
                    DateTask.resignFirstResponder()
                }
            }
