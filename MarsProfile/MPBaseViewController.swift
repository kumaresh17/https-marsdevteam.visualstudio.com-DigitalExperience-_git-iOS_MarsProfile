//
//  MPBaseViewController.swift
//  MarsProfile
//
//  Created by TechMadmin on 10/08/17.
//  Copyright © 2017 com.mars.MarsProfile. All rights reserved.
//

import UIKit

class MPBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarTitle()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationBarTitle(){
        let image = UIImage(named: "ProfileLogo-WithTextWhite.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 110.0, height: (self.navigationController?.navigationBar.bounds.size.height)!-15.0)
        let view = UIView(frame:CGRect(x: 10, y: -15.0, width: 110.0, height: (self.navigationController?.navigationBar.bounds.size.height)!-15.0))
        view.addSubview(imageView)
        self.navigationItem.titleView = view
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
