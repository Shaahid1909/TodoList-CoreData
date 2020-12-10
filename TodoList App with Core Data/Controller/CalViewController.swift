
import UIKit
import FSCalendar
import CoreData

class CalViewController: UIViewController,FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource {
    
   var categories = [Category]()

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


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
    @IBOutlet var tableView: UITableView!
    
    var calendarView:FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView = FSCalendar(frame: CGRect(x: 2.0, y: 90.0, width: self.view.frame.size.width, height: 300.0))
        // Do any additional setup after loading the view.
        setupCalendar()
        //calendarView.layer.cornerRadius = 10
        calendarView.layer.borderColor = UIColor.systemGray.cgColor
        //calendarView.layer.borderWidth = 0.3
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.backgroundColor = UIColor.white
       // tableView.contentInset = UIEdgeInsets(top: self.view.bounds.height, left: 10, bottom: 10, right: 50)
      //  tableView.layer.cornerRadius = 10
        tableView.layer.borderColor = UIColor.systemGray.cgColor
     //   tableView.layer.borderWidth = 0.3
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        
//        tableView.register(UINib(nibName: "CalenderTableViewCell", bundle: nil), forCellReuseIdentifier: "CalenderTableViewCell")
        
        tableView.showsVerticalScrollIndicator = false
       //retrieveData()
        dateevent()
        tableView.reloadData()
        loadItems()
   // retrieveData()
    }
     func setupCalendar(){
            view.addSubview(calendarView)
            
           // calendarView.frame = view.frame
            calendarView.delegate = self
        }
        
    func dateevent(){
            var counts: [String: Int] = [:]

            for item in Task_Date_1 {
                counts[item] = (counts[item] ?? 0) + 1
            }

            for (key, value) in counts {
                if value > 1{
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
        dates_1 = dateFormatter.string(from: date)
//        dates_1.append(formattteddate)
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
//        fetchRequest.predicate = NSPredicate(format: "date == %@", "\(formattteddate)")
//        do {
//           categories = try context.fetch(fetchRequest)
////            tableView.reloadData()
////            for data in fetchreult as! [NSManagedObject] {
////                Task_Note.append(data.value(forKey: "notes") as! String)
////                Task_Date.append(data.value(forKey: "end_date") as! String)
////                Task_Category.append(data.value(forKey: "category") as! String)
////                            }
//
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        tableView.reloadData()
    }
    

//    func retrieveData() {
//
//             var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//             let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
//             do {
//
//                 let result = try context.fetch(fetchRequest)
//                 for data in result as! [NSManagedObject] {
//                     Task_Date_1.append(data.value(forKey: "date") as! String)
//                 }
//
//             } catch {
//
//                 print("Failed")
//             }
//
//
//         }
//
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        let predicate = NSPredicate(format: "date == %@", dates_1)
        request.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
        do {
          categories = try context.fetch(request)

            tableView.reloadData()
            if categories.isEmpty == true {
               print("pressed")
            }
        } catch {
            print("error loading data \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderTableViewCell",for: indexPath) as! CalenderTableViewCell
    
        
          cell.CalLabel.text = categories[indexPath.row].name
             print(categories[indexPath.row].name!)
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
    


