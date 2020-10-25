//
//  ViewController.swift
//  RxswiftAlamofirePractice
//
//  Created by 松尾淳平 on 2020/10/25.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    var alamofireButton = UIButton()
    var rxSwiftButton = UIButton()
    
    let disposeBug = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        alamofireButton.backgroundColor = .darkGray
        alamofireButton.setTitle("Alamofire", for:  .normal)
        alamofireButton.rx.tap.subscribe({[unowned self] _ in
            print("タップされたよ")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let alamofireExampleViewController = storyBoard.instantiateViewController(identifier: "AlamofireExampleViewController")
            self.navigationController?.pushViewController(alamofireExampleViewController, animated: true)
        }).disposed(by: disposeBug)
        rxSwiftButton.setTitle("RxSwift", for: .normal)
        rxSwiftButton.backgroundColor = .darkGray
        rxSwiftButton.rx.tap.subscribe {[unowned self] _ in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let rxSwiftExampleController = storyBoard.instantiateViewController(identifier: "RxSwiftExampleViewController")
            self.navigationController?.pushViewController(rxSwiftExampleController, animated: true)
        }
        self.view.addSubview(rxSwiftButton)
        self.view.addSubview(alamofireButton)
        
        
    }
    override func viewDidLayoutSubviews() {
//        AutoLayoutを使うと、AutoLayout以外で設定していたフレーム（サイズも）が効かなくなるので、どっちかに倒した方が良い。
//        ここでは、フレーム（座標とサイズ）をAutoLayoutで決定した。
        do{
            rxSwiftButton.translatesAutoresizingMaskIntoConstraints = false
            rxSwiftButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            rxSwiftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 5).isActive = true
            rxSwiftButton.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
            rxSwiftButton.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        }
        do{
            alamofireButton.translatesAutoresizingMaskIntoConstraints = false
            alamofireButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            alamofireButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width / 5).isActive = true
            alamofireButton.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
            alamofireButton.heightAnchor.constraint(equalToConstant:view.frame.width / 4 ).isActive = true
        }
    }
}

