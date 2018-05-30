//
//  HomeViewController.swift
//  Vigia App
//
//  Created by Osniel Lopes Teixeira on 28/04/2018.
//  Copyright © 2018 Osniel Lopes Teixeira. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var menuContainer: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "menuMorador") as? MenuMoradorViewController else {
            fatalError("Impossible to convert the viewController to MenuVisitanteViewController")
        }
        controller.superViewController = self
        self.addChildViewController(controller)
        controller.view.frame = CGRect(x: 0, y: 0, width: menuContainer.frame.width, height: menuContainer.frame.height)
        menuContainer.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
