//
//
import UIKit
import SwiftyDropbox
import Foundation

class ImgViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

// Acciòn del botòn para ligar la aplicaciòn con la cuenta de dropbox
// Es necesario hacerlo para descarga los documentos de esa cuenta
//
//    @IBAction func linkButtonPressed(sender: AnyObject) {
//        Dropbox.authorizeFromController(self)
//    }
    
    var path6 = "" // variable que toma el valor del nombre
                   // de la imagen a desplegar, seleccionada
                   // desde la pantalla anterior (tabla).
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Define la escala máxima del zoom
        self.scrollView.maximumZoomScale = 6.0
        
        // Método que sirve para quitar el vinculo de la
        // aplicación con la cuenta de Dropbox.
        // Dropbox.unlinkClient()
        //
        
        
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            // Upload a file
            
                    let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                        let fileManager = NSFileManager.defaultManager()
                        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                        // generate a unique name for this file in case we've seen it before
                        let UUID = NSUUID().UUIDString
                        let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                        return directoryURL.URLByAppendingPathComponent(pathComponent)
                    }
                    
                    client.files.download(path: self.path6, destination: destination).response { response, error in
                        if let (metadata, url) = response {
                            print("*** Download file ***")
                            self.activityIndicator.startAnimating()
                            let data = NSData(contentsOfURL: url)
                            let sesion = NSURLSession.sharedSession()
                            let dir = "https://www.ajegroup.com/wp-content/uploads/2014/05/BIG.jpg"
                            if let url = NSURL(string: dir){
                                let tarea = sesion.dataTaskWithURL(url, completionHandler: { (datos, response, error) -> Void in
                                    let imagen = UIImage(data: data!)
                                    dispatch_async(dispatch_get_main_queue(), { () ->
                                        Void in
                                        self.imgView.image = imagen
                                        self.activityIndicator.stopAnimating()
                                    })
                                    // el dispatch tambien se podria aplicar al texto
                                    
                                })
                                tarea.resume() // Inicia la descarga
                            }

                            print("Downloaded file name: \(metadata.name)")
                            print("Downloaded file url: \(url)")
                            //print("Downloaded file data: \(data)")
                        } else {
                            print(error!)
                        }
                    }
                    
        }
                // Do any additional setup after loading the view.

    }
    

    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        // Define a que elemento se le va a poder  hacer zoom
        return self.imgView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}
