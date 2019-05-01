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
        
        let dbPath = self.getDBPath()
        self.dbExecute(dbPath: dbPath)
    }
    
    // 데이터베이스 경로를 가져오는 메소드
    func getDBPath() -> String {
        
        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일을 찾는다
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        
        // dbPath 경로에 파일이 없다면 앱 번들에서 만들어 둔 db.sqlite를 가져와 복사
        if fileMgr.fileExists(atPath: dbPath) == false {    // dbPath 경로에 파일 유무를 체크
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")    // 앱 번들에 포함된 db.sqlite 파일의 경로를 읽어온다
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)    // dbPath에 db.sqlite 파일을 복사한다
        }
        
        return dbPath
    }
    
    // 해당 sql을 데이터베이스에 적용하는 메소드
    func dbExecute(dbPath: String) {
        var db: OpaquePointer? = nil    // SQLite 연결 정보를 담을 객체
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("연결 실패")
            return
        }
        
        // 지연 블록 -> 데이터베이스 연결 종료
        defer {
            print("데이터베이스 연결 종료")
            sqlite3_close(db)
        }
        
        var stmt: OpaquePointer? = nil  // 컴파일된 SQL을 담을 객체
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)"
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            print("컴파일 실패")
            return
        }
        
        // 지연 블록 -> stmt 객체 해제
        defer {
            print("stmt 객체 해제")
            sqlite3_finalize(stmt)
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("데이터베이스 성공")
        }
    }
}

