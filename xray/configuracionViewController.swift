//
//  configuracionViewController.swift
//  xray
//
//  Created by Lalo Castilla on 4/10/16.
//  Copyright © 2016 EquipoDispMoviles. All rights reserved.
//

import UIKit
import SwiftyDropbox
class configuracionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func vincular(sender: AnyObject) {
        Dropbox.authorizeFromController(self)
        
    }
    
    @IBAction func desvincular(sender: AnyObject) {
        Dropbox.unlinkClient()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
