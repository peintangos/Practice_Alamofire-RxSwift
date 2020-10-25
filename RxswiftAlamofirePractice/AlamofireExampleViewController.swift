//
//  AlamofireExampleViewController.swift
//  RxswiftAlamofirePractice
//
//  Created by 松尾淳平 on 2020/10/25.
//

import UIKit
import Alamofire
class AlamofireExampleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quitaList?.count ?? 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = quitaList?[(indexPath as NSIndexPath).row].title ?? "a"
//        print("何が挿入されているか\(quitaList![(indexPath as NSIndexPath).row].title)")
        return cell
    }
    var quitaList:[Article]?
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
    }
    override func viewDidAppear(_ animated: Bool) {
        let statusBar:CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        print(statusBar)
        let navigatonBar:CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
        let mainView = UIView(frame: CGRect(x: 0, y: statusBar + navigatonBar, width: view.frame.width, height: view.frame.height / 4))
        self.view.addSubview(mainView)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue.cgColor,UIColor.systemBlue.cgColor]
//        frameを決定してあげないと、表示されないので注意
        gradientLayer.frame = mainView.frame
        gradientLayer.locations = [0.2,0.6]
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.1, y: 1)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: statusBar + navigatonBar + view.frame.height / 4, width: view.frame.width, height: view.frame.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        update()
    }
    func update(){
        AF.request("https://qiita.com/api/v2/items").responseJSON{ (response) in
            let decoder: JSONDecoder = JSONDecoder()
            do{
                let articles: [Article] = try decoder.decode([Article].self, from: response.data!)
                self.quitaList = articles
                self.tableView.reloadData()
                print("アーティクルには入っている\(articles)")
            }catch{
                print("failed")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
