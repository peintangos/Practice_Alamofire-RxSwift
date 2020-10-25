//
//  RxSwiftExampleViewController.swift
//  RxswiftAlamofirePractice
//
//  Created by 松尾淳平 on 2020/10/25.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

class RxSwiftExampleViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quitaList?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = self.quitaList?[(indexPath as NSIndexPath).row].title ?? "ロード中"
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        httpRequest(word: textField.text!)
        return true
    }
    
    
//    下記の方法(宣言時に初期化するか、viewDidLoadeで初期化するかどちらも変わらないのであれば、宣言時に初期化したほうが良いか。
    var textField=UITextField()
    var label = UILabel()
    var labelTitle = UILabel()
    var mainView = UIView()
    let disposeBug = DisposeBag()
    var quitaList:[Article]?
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.delegate = self
    
        
        do{
            textField = UITextField()
            textField.borderStyle = .roundedRect
            textField.placeholder = "何か入力"
            textField.keyboardType = .default
            textField.clearButtonMode = .whileEditing
            textField.delegate = self
            self.view.addSubview(textField)
        }
        do{
            label.text = "入力された文字が入るよ"
            label.textColor = .black
            label.textAlignment = NSTextAlignment.center
            label.backgroundColor = .systemPink
            self.view.addSubview(label)
        }
        do{
            let statusBar:CGFloat = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
            let navigatonBar:CGFloat = (self.navigationController?.navigationBar.frame.size.height) ?? 44
            let sumHeight = statusBar + navigatonBar
            
            mainView = UIView(frame: CGRect(x: 0, y: sumHeight, width: self.view.frame.width, height: self.view.frame.height / 4))
            
            labelTitle.text = "RxSwift"
            labelTitle.textColor = .white
            labelTitle.textAlignment = NSTextAlignment.center
            mainView.addSubview(labelTitle)
            
            var layer = CAGradientLayer()
            layer.frame = mainView.frame
            layer.colors = [UIColor.green.cgColor,UIColor.systemGreen.cgColor]
            layer.locations = [0.1,0.7]
            layer.startPoint = CGPoint(x: 0.3, y: 0)
            layer.endPoint = CGPoint(x: 0.2, y: 1)
            

            self.view.layer.insertSublayer(layer, at: 0)
            self.view.addSubview(mainView)
        }
        
        do{
            let statusBar:Int =  20
            let navigatonBar:Int =  44
            let gradietHeight:Int = Int(self.view.frame.height / 4)
            let textFieldHeight:Int = 100
            let sumHeight = statusBar + navigatonBar + gradietHeight + textFieldHeight
            
            tableView = UITableView(frame: CGRect(x: 0, y: CGFloat(sumHeight), width: view.frame.width, height: view.frame.height), style: .grouped)
            tableView.dataSource = self
            tableView.delegate = self
            self.view.addSubview(tableView)
        }
        textField.rx.text.bind(to: label.rx.text).disposed(by: disposeBug)
        
        httpRequest()
        
    }
    func httpRequest(word:String){
        AF.request("https://qiita.com/api/v2/items?body=\(word)").responseJSON { (response) in
            let jsonDecoder = JSONDecoder()
            do{
//                初めてguare letを使った。response.dataがnilで、強制アンラップするとクラッシュすることがあったので。
                guard let result = response.data else {
                    print("ss")
                    return
                }
                let article:[Article] = try jsonDecoder.decode([Article].self,from:response.data!)
                self.quitaList = article
                self.tableView.reloadData()
                print("一応結果は来ている\(article)")
            }catch{
                print("error")
            }
        }
    }
    func httpRequest(){
        AF.request("https://qiita.com/api/v2/items").responseJSON { (response) in
            let jsonDecoder = JSONDecoder()
            do{
                let article:[Article] = try jsonDecoder.decode([Article].self,from:response.data!)
                self.quitaList = article
                self.tableView.reloadData()
            }catch{
                print("error")
            }
        }
    }
    override func viewDidLayoutSubviews() {

        do{
            mainView.translatesAutoresizingMaskIntoConstraints = false
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 64).isActive = true
            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        do{
            labelTitle.translatesAutoresizingMaskIntoConstraints = false
            //        self.view.frame.height / 4 がviewの高さなので、ちょうど真ん中にするために半分に設定
            labelTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64 + self.view.frame.height / 8).isActive = true
            labelTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            //        本当は、下記のようにx軸、y軸共に親viewの真ん中という様にしたかったが、できなかった
            //        labelTitle.centerYAnchor.constraint(equalTo: labelTitle.superview!.centerYAnchor).isActive = true
        }
        do{
            textField.translatesAutoresizingMaskIntoConstraints = false
//            64はステータスバーとナビゲーションバーの高さで、self.view.frame.heightはぐらーでションをしている部分の高さ。20足したのは少しスペースを開けたかったから
            textField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height / 4 + 64 + 20).isActive = true
            textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            textField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 30).isActive = true
        }
        do{
            label.translatesAutoresizingMaskIntoConstraints = false
//
            label.topAnchor.constraint(equalTo: self.view.topAnchor, constant:self.view.frame.height / 4 + 120).isActive  = true
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: self.view.frame.width - 30).isActive = true
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
