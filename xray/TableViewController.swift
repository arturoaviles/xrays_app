//
//  
//

import UIKit
import SwiftyDropbox

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Probando branch
    var imagesArray = [ImageItem]() // Arreglo de todas las imagenes
    var filteredImages = [ImageItem]() //Arreglo imagenes filtradas
    let lbEstado = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var reach: Reachability?
        
        //self.title = "Title"
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.blueColor()
        
        // Pruebas Navigation Items
        
        //let leftButton =  UIBarButtonItem(title: "Left Button", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let rightButton = UIBarButtonItem(title: "Actualizar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(TableViewController.actualizarDropbox))
        
        //self.tabBarController?.navigationItem.leftBarButtonItem = leftButton
        self.tabBarController?.navigationItem.rightBarButtonItem = rightButton
        
        //self.tabBarController?.navigationItem.prompt = "no mames"
        
        //self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.greenColor()]
        self.tabBarController?.navigationItem.title = "X-Ray"
        
        //self.navigationController?.navigationBar.barStyle.rawValue
        
        
        self.tableView.reloadData() //Carga la tabla con las
                                    //imagenes encontradas
        
        reach = Reachability.reachabilityForInternetConnection()
        
        reach!.reachableBlock = {
            (let reach: Reachability!) -> Void in
            print("Hay red")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                /*self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.greenColor()]
                self.tabBarController?.navigationItem.title = "Estado: Conectado a internet"
                self.lbEstado.text = "Estado: Conectado a internet"
                self.lbEstado.textColor = UIColor.greenColor()*/
                self.tableView.allowsSelection = true;
            })
        }
        
        reach!.unreachableBlock = {
            (let reach: Reachability!) -> Void in
            print("No hay RED")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                /*self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
                self.tabBarController?.navigationItem.title = "Estado: Sin conexión a internet"*/
                self.alerta(3)
                self.tableView.allowsSelection = false;
            })
        }
        
        reach?.startNotifier()
        
        let estado = reach!.currentReachabilityStatus()
        if estado == NetworkStatus.NotReachable {
            /*self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
            self.tabBarController?.navigationItem.title = "Estado: Sin conexión a internet"*/
            self.alerta(3)
            tableView.allowsSelection = false;

        } else {
            /*self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.greenColor()]
            self.tabBarController?.navigationItem.title = "Estado: Conectado a internet"*/
            tableView.allowsSelection = true;
        }



    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    
    /// Metodos que permiten que la barra siempre esté visible
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden = false
    }
    ///
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Dropbox
    
    func actualizarDropbox() {
        self.imagesArray.removeAll()
        self.filteredImages.removeAll()
        self.tableView.reloadData()
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                //print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
                //print("*** List folder ***")
                if let result = response {
                    //print("Folder contents:")
                    
                    for entry in result.entries {
                        print(entry.name)
                        
                        //Filtro para mostrar solamente imagenes
                        if entry.name.hasSuffix(".jpg") || entry.name.hasSuffix(".png")||entry.name.hasSuffix(".jpeg") {
                            //Agrega nombre de la imagen a la tabla
                            //self.imgArray.append(entry.name)
                            self.imagesArray += [ImageItem(name: entry.name)]
                        }
                        //Actualiza la tabla con los nuevos elementos
                        self.tableView.reloadData()
                    }
                    if self.imagesArray.isEmpty == true  {
                        self.alerta(1)
                    }
                } else {
                    print(error!)
                }
            }
            
            
        } else {
            self.alerta(2)
        }
    }
    
    func alerta(num: Int){
        var titulo = ""
        var message = ""
        switch num {
        case 1:
            titulo = "Vacio"
            message = "No hay imagenes en la cuenta"
            break
        case 2:
            titulo = "Cuenta"
            message = "No hay cuenta vinculada"
            break
        case 3:
            titulo = "Internet"
            message = "NO esta conectado a Internet"
        default:
            titulo = "Vacio"
            message = "No hay imagenes en la cuenta"
        }
        let alerta = UIAlertController(title: titulo, message: message, preferredStyle: .Alert)
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .Default, handler: { (accion: UIAlertAction) -> Void in
            //
        })
        alerta.addAction(accionAceptar)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    


    // MARK: - Table view data source

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var image : ImageItem
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {   // si se está usando la barra de busqueda
            image = self.filteredImages[indexPath.row]
        }
        else
        {
            // si no se está usando la barra de busqueda
            image = self.imagesArray[indexPath.row]
        }
        
        // ir a la siguiente pantalla tomando una copia del nombre de
        // la imagen a desplegar
        
        performSegueWithIdentifier("irImagen", sender:image.name

        )
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let info = segue.destinationViewController as!ImgViewController // as! supon que existe
        var path5 = "/"
        path5+=sender as! String
        info.path6 = path5
        
    }
    

    
    
    func filterContenctsForSearchText(searchText: String, scope: String = "Title"){
        self.filteredImages = self.imagesArray.filter({( image :ImageItem) -> Bool in
            let categoryMatch = (scope == "Title")
            let stringMatch = image.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return categoryMatch && (stringMatch != nil)
        })

    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool
    {
        
        self.filterContenctsForSearchText(searchString, scope: "Title")
        
        return true
        
        
    }
    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool
    {
        
        self.filterContenctsForSearchText(self.searchDisplayController!.searchBar.text!, scope: "Title")
        
        return true
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            return self.filteredImages.count
        }
        else
        {
            return self.imagesArray.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("celdaImagen")! as UITableViewCell
        
        var image : ImageItem
        
        if (tableView == self.searchDisplayController?.searchResultsTableView)
        {
            image = self.filteredImages[indexPath.row]
        }
        else
        {
            image = self.imagesArray[indexPath.row]
        }
        
        
        cell.textLabel?.text = image.name
        //cruzrojaradiografias@gmail.com
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        self.actualizarDropbox()
    }


}
