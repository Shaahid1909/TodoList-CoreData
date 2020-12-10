

import UIKit
import FloatingTabBarController

class ViewController: FloatingTabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let color = [#colorLiteral(red: 1, green: 0.4117647059, blue: 0.4117647059, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        let imagesArrLarge = [#imageLiteral(resourceName: "icons8-dog-house-100"),#imageLiteral(resourceName: "icons8-ok-100"),#imageLiteral(resourceName: "icons8-heart-100")]
        let imagesArrSmall = [#imageLiteral(resourceName: "icons8-dog-house-75"),#imageLiteral(resourceName: "icons8-ok-75"),#imageLiteral(resourceName: "icons8-heart-75")]
        
               var count = 0
               
        
               tabBar.tintColor = .black
               tabBar.backgroundColor = .white
               
               viewControllers = (1...3).map { "Tab\($0)" }.map {
                   
                   let selected = imagesArrLarge[count]
                   let normal = imagesArrSmall[count]
                   let controller = storyboard!.instantiateViewController(withIdentifier: $0)
                   controller.title = $0
                   
                   
                   controller.view.backgroundColor = color[count]
                   count  = count + 1
                   controller.floatingTabItem = FloatingTabItem(selectedImage: selected, normalImage: normal)
                   return controller
               }
    }
    }





