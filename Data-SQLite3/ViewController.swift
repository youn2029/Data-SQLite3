//
//  ViewController.swift
//  Data-SQLite3
//
//  Created by 윤성호 on 01/05/2019.
//  Copyright © 2019 윤성호. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var db: OpaquePointer? = nil        // SQLite 연결 정보를 담을 객체
        var stmt: OpaquePointer? = nil      // 컴파일된 SQL을 담을 객체
        
        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일을 찾는다
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        
        // dbPath 경로에 파일이 없다면 앱 번들에서 만들어 둔 db.sqlite를 가져와 복사한다.
        if fileMgr.fileExists(atPath: dbPath) == false {    // dbPath 경로에 파일 유무를 체크
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")    // 앱 번들에 포함된 db.sqlite 파일의 경로를 읽어온다
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)    // dbPath에 db.sqlite 파일을 복사한다
        }
        
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"
        
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK { // DB 연결이 성공하면
            
            if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK {  // 컴파일이 성공하면
                
                if sqlite3_step(stmt) == SQLITE_DONE {  // 컴파일된 SQL 객체가 DB에 전달이 성공하면
                    print("전달 성공")
                }
                sqlite3_finalize(stmt)  // 컴파일된 SQL 삭제
                
            }else { // 컴파일 실패
                print("컴파일 실패")
            }
            sqlite3_close(db)   // DB 연결 종료
            
        }else { // DB 연결 실패
            print("DB 연결 실패")
            return
        }
    }


}

