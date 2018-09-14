//
//  ViewController.swift
//  Exemplo Rest Json 2TDSA
//
//  Created by Usuário Convidado on 14/09/18.
//  Copyright © 2018 Gustavo André Lei. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet weak var imgPark: UIImageView!;
    @IBOutlet weak var lblPlace: UILabel!;
    @IBOutlet weak var lblState: UILabel!;
    
    // Empty session for request
    var session: URLSession?;
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showData(_ sender: Any)
    {
        // Create seassion configuration as default
        let config = URLSessionConfiguration.default;
        
        // Create a new seassion using default configuration
        session = URLSession(configuration: config);
        
        let url = URL(string: "https://parks-api.herokuapp.com/parks/577024e4a44821110001ee93");
        
        // Make request
        let task = session!.dataTask(with: url!) { (data, response, error) in
            /*let texto = NSString(data: data!, encoding: String.Encoding.utf8.rawValue);
             print(texto!)*/
            if let place = self.parseJsonData(data: data!, type: "nome") {
                if let state = self.parseJsonData(data: data!, type: "estado") {
                    if let img = self.parseJsonData(data: data!, type: "urlfoto") {
                        DispatchQueue.main.async {
                            self.lblPlace.text = place;
                            self.lblState.text = state
                           self.loadImageByUrl(imgUrl: img);
                        }
                    }
                }
            }
        }
        
        
        task.resume();
    }
    
    func parseJsonData(data:Data, type:String)-> String?
    {
        var parsedData:String? = nil;
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject];
            if let jsonData = json[type] as? String {
                print(jsonData)
                parsedData = jsonData;
            }
        } catch let error as NSError {
           return "Falha ao carregar :\(error.localizedDescription)"
        }
        return parsedData;
    }
    
    func loadImageByUrl(imgUrl: String)
    {
        let myUrl = URL(string: imgUrl);
        let url = URLRequest(url: myUrl!);
        
        let session = URLSession.shared;
        let task = session.dataTask(with: url) { (data, response, error) in
            if let imgData = data{
                DispatchQueue.main.async {
                    self.imgPark.image = UIImage(data: imgData);
                }
            }
        }
        task.resume();
    }
}

