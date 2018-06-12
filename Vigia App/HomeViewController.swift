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
    
    func setupMenu() {
        
        let nivelAcesso = UserDefaults().integer(forKey: "nivel_acesso")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch nivelAcesso {
        case 0:
            guard let controller = storyboard.instantiateViewController(withIdentifier: "menuMorador") as? MenuMoradorViewController else {
                fatalError("Impossible to convert the viewController to MenuMoradorViewController")
            }
            controller.superViewController = self
            self.addChildViewController(controller)
            controller.view.frame = CGRect(x: 0, y: 0, width: menuContainer.frame.width, height: menuContainer.frame.height)
            menuContainer.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        case 1:
            guard let controller = storyboard.instantiateViewController(withIdentifier: "menuGestor") as? MenuGestorViewController else {
                fatalError("Impossible to convert the viewController to MenuGestorViewController")
            }
            controller.superViewController = self
            self.addChildViewController(controller)
            controller.view.frame = CGRect(x: 0, y: 0, width: menuContainer.frame.width, height: menuContainer.frame.height)
            menuContainer.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        case 2:
            guard let controller = storyboard.instantiateViewController(withIdentifier: "menuVisitante") as? MenuVisitanteViewController else {
                fatalError("Impossible to convert the viewController to MenuVisitanteViewController")
            }
            controller.superViewController = self
            self.addChildViewController(controller)
            controller.view.frame = CGRect(x: 0, y: 0, width: menuContainer.frame.width, height: menuContainer.frame.height)
            menuContainer.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        setupMenu()

    }
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        
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
