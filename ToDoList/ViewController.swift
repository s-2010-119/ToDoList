//
//  ViewController.swift
//  ToDoList
//
//  Created by Nancy on 2020/09/02.
//  Copyright © 2020 Swift-Beginners. All rights reserved.
//

import UIKit

//①変更：プロトコル（UITableViewDataSource, UITableViewDelegate）の追加
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var alertController: UIAlertController!
    
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
    }
    
    // ②追加：テーブルに表示するデータの箱
    var toDoList = [String]()
    // 追記：インスタンスの生成
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 追記：データ読み込み
        if let storedToDoList = userDefaults.array(forKey: "toDoList") as? [String] {
            toDoList.append(contentsOf: storedToDoList)
        }
    }

    @IBAction func addButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "追加", message: "ToDoを入力してください", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
            // 追加：OKをタップした時の処理
            if let textField = alertController.textFields?.first {
                
                    //入力がないときはエラーを返す
                    guard textField.text! != "" else {
                        return self.alert(title: "エラー", message: "ToDoを入力してください")
                    }
                
                self.toDoList.append(textField.text!)
                self.tableView.insertRows(at: [IndexPath(row: self.toDoList.count - 1, section: 0)], with: .none)
                
            // 追記：追加したToDoを保存
            self.userDefaults.set(self.toDoList, forKey: "toDoList")
            }
        }
        alertController.addAction(okAction)
        let cancelButton = UIAlertAction(title: "戻る", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    // ③追加：セルの数を指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    // ④追加：セルの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        //複数行表示
        cell.textLabel?.numberOfLines = 0
        
        let toDoTitle = toDoList[indexPath.row]
        cell.textLabel?.text = toDoTitle
        return cell
    }
    
    // 追加：セルの削除機能
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            toDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            // 追加：削除した内容を保存
            userDefaults.set(toDoList, forKey: "toDoList")
        }
    }
}

