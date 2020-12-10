

import UIKit
import FSCalendar
import CoreData

class CalenderViewController: UIViewController,FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource {
    
   
    
    var dateView = UIPickerView()
    
    let start_end_date = UIDatePicker()
    
    @IBOutlet var BlurEffect: UIVisualEffectView!
    
    @IBOutlet var PopView: UIView!
   
    
    
        func datepickerbirth(){
            let toolbar=UIToolbar()
            toolbar.sizeToFit()
            let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(doneselect))
            toolbar.setItems([done], animated: false)
            SetRemind.inputAccessoryView=toolbar
             start_end_date.datePickerMode = .time
            SetRemind.inputView = start_end_date
           
        }
        
        @objc func doneselect() {
            let date: String
            let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "HH:mm"//this your string date
            let convertedDate = dateFormatter.string(from: start_end_date.date)
                SetRemind.text = "\(convertedDate)"
            self.view.endEditing(true)
            
        }
        
        func joinpicker(){
            let toolbar=UIToolbar()
            toolbar.sizeToFit()
            let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(joinselect))
            toolbar.setItems([done], animated: false)
         
        }
        
        @objc func joinselect(){
            let dateformat=DateFormatter()
            dateformat.dateStyle = .medium
            dateformat.timeStyle = .none
    //        let datestring = dateformat.string(from: end_date.date)
    //        EndDate.text="\(datestring)"
            self.view.endEditing(true)
       
    
    }
    var categories = [Category]()

    @IBOutlet var SetRemind: UITextField!
    
    
    @IBAction func RemindAction(_ sender: Any) {
        animateIn(desiredView: BlurEffect)
                  animateIn(desiredView: PopView)
    }
    
    @IBAction func animatedout(_ sender: Any) {
           
           animatedismiss(desiredView: PopView)
           animatedismiss(desiredView: BlurEffect)
       }
       
       @IBAction func AddTime(_ sender: Any) {
           
      animatedismiss(desiredView: PopView)
             animatedismiss(desiredView: BlurEffect)
        SetRemind.text = ""
        

        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "You have tasks for today!"
        content.sound = .default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }

        }
        
        
        
        
           
       }
    
    
    func animateIn(desiredView:UIView){
          
          let backgroundView = self.view
          backgroundView?.addSubview(desiredView)
          desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
          desiredView.alpha = 0
          desiredView.center = backgroundView?.center as! CGPoint
          UIView.animate(withDuration: 0.3, animations: {
          desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
          desiredView.alpha = 1

          })
          
      }
      func  animatedismiss(desiredView:UIView){
          UIView.animate(withDuration: 0.3, animations: {
              desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
              desiredView.alpha = 0
          },completion: { _ in desiredView.removeFromSuperview()} )
      }
    
    
    
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//    var Task_Note:[String] = []
    var Task_Date:[String] = []
    var Task_Category:[String] = []
    var Task_Date_1:[String] = []
    var dict = Dictionary<String, Array<String>>()
    var dates_1:String = ""
    var datesWithEvent:[String] = []
    var datesWithMultipleEvents:[String] = []
    
  fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeZone = .none
        return formatter
    }()

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Calender_View: UIView!
    var CalenderView:FSCalendar = FSCalendar()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dateView.dataSource=self
//        dateView.delegate=self
//        SetRemind.inputView = dateView
//           start_end_date.datePickerMode = .dateAndTime
        BlurEffect.bounds = self.view.bounds
        PopView.bounds = CGRect(x: 2, y: 0, width: self.view.bounds.width * 0.5, height: self.view.bounds.height * 0.2)

        PopView.layer.cornerRadius = 10
                         PopView.layer.borderColor = UIColor.red.cgColor
                   PopView.layer.borderWidth = 0.3
               
        
        CalenderView.delegate = self
        CalenderView.dataSource = self
        Calender_View.backgroundColor = UIColor.white
        
        SetRemind.text = ""
//        tableView.layer.cornerRadius = 10
//        tableView.layer.borderColor = UIColor.systemGray.cgColor
//        tableView.layer.borderWidth = 0.3
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.register(UINib(nibName: "CalenderTableViewCell", bundle: nil), forCellReuseIdentifier: "CalenderTableViewCell")
        datepickerbirth()
           //   doneselect()
//               joinpicker()
//               joinselect()
     //   tableView.showsVerticalScrollIndicator = false
        retrieveData()
        dateevent()
        tableView.reloadData()

    }
    
    
    func dateevent(){
            var counts: [String: Int] = [:]

            for item in Task_Date_1 {
                counts[item] = (counts[item] ?? 0) + 1
            }

            for (key, value) in counts {
                if value > 1{
//                    print("\(key) occurs \(value) time(s)")
                    datesWithMultipleEvents.append(key)
                }
                else{
                    datesWithEvent.append(key)
                }
            }

    }
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattteddate = dateFormatter.string(from: date)
        dates_1.append(formattteddate)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "date == %@", "\(formattteddate)")
        do {
           categories = try context.fetch(fetchRequest)

        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func retrieveData() {

            var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
            do {

                let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    Task_Date_1.append(data.value(forKey: "date") as! String)
                }

            } catch {

                print("Failed")
            }


        }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let doneAction = UIContextualAction(style: .normal, title: "☑️") {(action, view, completionHandler) in


          self.categories.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .automatic)
                          completionHandler(true)
              }
              
              doneAction.backgroundColor = .systemGreen
              doneAction.image = #imageLiteral(resourceName: "29")
                  
             let actionLike = UIContextualAction(style: .destructive, title: "🤍") {(action, view, completionHandler) in
             completionHandler(true)

              
              
                  let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpID") as! signupPopupController
              self.addChild(popOverVC)
                  
                         popOverVC.view.frame = self.view.frame
                         self.view.addSubview(popOverVC.view)
              popOverVC.didMove(toParent: self)

              }
          actionLike.backgroundColor = .systemPink
//          let CatAction = UIContextualAction(style: .normal, title: "") {(action, view, completionHandler) in completionHandler(true)
//          }
//                         CatAction.backgroundColor = .systemBlue
//                      CatAction.image = #imageLiteral(resourceName: "29-1")
                  return UISwipeActionsConfiguration(actions: [doneAction, actionLike])
                //  return swipeActions
              
              }
          
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderTableViewCell",for: indexPath) as! CalenderTableViewCell
        cell.CalLabel.text = categories[indexPath.row].name
        print(categories[indexPath.row].name!)
        if (categories[indexPath.row].category == "Others"){
        cell.imageViewcal.image = UIImage(named: "comm.jpg")
        }else if (categories[indexPath.row].category == "Shopping") {
            cell.imageViewcal.image = UIImage(named: "bag.jpg")
        }else if (categories[indexPath.row].category == "Home") {
            cell.imageViewcal.image = UIImage(named: "house.png")
        }else if (categories[indexPath.row].category == "Personal") {
            cell.imageViewcal.image = UIImage(named: "comm.jpg")
        }else if (categories[indexPath.row].category == "Wishlist") {
            cell.imageViewcal.image = UIImage(named: "wishlist.png")
        }else if (categories[indexPath.row].category == "Study") {
            cell.imageViewcal.image = UIImage(named: "study.png")
        }else if (categories[indexPath.row].category == "Travel") {
            cell.imageViewcal.image = UIImage(named: "travel.png")
        }else if (categories[indexPath.row].category == "Occasions") {
            cell.imageViewcal.image = UIImage(named: "bag.png")
        } else if (categories[indexPath.row].category == "Official"){
            cell.imageViewcal.image = UIImage(named: "comm.png")
        }else if (categories[indexPath.row].category == "Inbox"){
            cell.imageViewcal.image = UIImage(named: "inbox.png")
        }else if (categories[indexPath.row].category == "Meeting"){
            cell.imageViewcal.image = UIImage(named: "comm.png")
        }else{
            cell.imageViewcal.image = UIImage(named: "wallet.png")
        }
        
        return cell
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateString = self.dateFormatter2.string(from: date)

        if self.datesWithEvent.contains(dateString) {
            
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())

            calendar.appearance.eventDefaultColor = UIColor(red:red, green: green, blue: blue, alpha: 1)
            return 1
        }
        if self.datesWithMultipleEvents.contains(dateString) {
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())

            calendar.appearance.eventDefaultColor = UIColor(red:red, green: green, blue: blue, alpha: 1)
            return 3
        }
        return 0
    }
    
    
}
