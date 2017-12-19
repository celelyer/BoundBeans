//
//  GameScene.swift
//  BoundBeans
//
//  Created by セロラー on 2017/11/27.
//  Copyright © 2017年 mikiya.tadano. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var myButton: UIButton!
    
    var play = 0
    
    var scrollCount: CGFloat = 0.0
    var leafNo: CGFloat = 0.0
    var kiNo: CGFloat = 0.0
    var deletecount: CGFloat = 0.0
    var deleteNo: CGFloat = 0.0
    
    var health = 0
    var healthLabelNode:SKLabelNode!
    var pointLabelNode:SKLabelNode!
    var bestScoreLabelNode:SKLabelNode!
    var point = 0
    let userDefaults:UserDefaults = UserDefaults.standard
    
    var mame:SKSpriteNode!
    var backScreenNode:SKSpriteNode!
    var Leaf:SKSpriteNode!
    var ki:SKSpriteNode!
    var scrollNode:SKNode!
    var deleteNode:SKNode!
    
    //衝突判定カテゴリー
    let mameCategory: UInt32 = 1 << 0
    let leafCategory: UInt32 = 1 << 1
    let scrollCategory: UInt32 = 1 << 2
    let kiCategory: UInt32 = 1 << 3
    let deleteCategory: UInt32 = 1 << 4
    let backScreenCategory: UInt32 = 1 << 5
    
    //SKView上にシーンが表示された時に呼ばれるメソッド
    override func didMove(to view: SKView) {
        // Buttonを生成する.
        myButton = UIButton()
        play = 0
        
        // ボタンのサイズ.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        // ボタンのX,Y座標.
        let posX: CGFloat = self.view!.frame.width/2 - bWidth/2
        let posY: CGFloat = self.view!.frame.height/2 - bHeight/2
        
        // ボタンの設置座標とサイズを設定する.
        myButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        
        // ボタンの背景色を設定.
        myButton.backgroundColor = UIColor.red
        
        // ボタンの枠を丸くする.
        myButton.layer.masksToBounds = true
        
        // コーナーの半径を設定する.
        myButton.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        myButton.setTitle("Start", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        //myButton.setTitle("ボタン(押された時)", for: .highlighted)
        //myButton.setTitleColor(UIColor.black, for: .highlighted)
        
        // ボタンにタグをつける.
        myButton.tag = 1
        
        // イベントを追加する
        myButton.addTarget(self, action: #selector(onClickMyButton(sender:)), for: .touchUpInside)
        
        // ボタンをViewに追加.
        self.view!.addSubview(myButton)
        
    }
    
    @objc func onClickMyButton(sender : UIButton){
        myButton.removeFromSuperview()
        play = 1
        print("Start")
        //重力を設定
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.8)
        physicsWorld.contactDelegate = self
        
        
        //背景色を設定
        backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        backScreenNode = SKSpriteNode()
        backScreenNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        backScreenNode.physicsBody = SKPhysicsBody(circleOfRadius: 0.1)
        backScreenNode.physicsBody?.mass = 0.07
        backScreenNode.physicsBody?.isDynamic = true
        backScreenNode.physicsBody?.allowsRotation = false
        backScreenNode.physicsBody?.linearDamping = 0.3
        backScreenNode.physicsBody?.categoryBitMask = backScreenCategory
        backScreenNode.physicsBody?.contactTestBitMask = deleteCategory
        backScreenNode.physicsBody?.collisionBitMask = mameCategory
        backScreenNode.name = "BackScreen"
        addChild(backScreenNode)
        
        
        deleteNode = SKNode()
        deleteNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 10)
        deleteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        deleteNode.physicsBody?.categoryBitMask = deleteCategory
        deleteNode.physicsBody?.contactTestBitMask = kiCategory | leafCategory
        deleteNode.physicsBody?.collisionBitMask = mameCategory
        deleteNode.physicsBody?.isDynamic = false
        deleteNode.name = "delete"
        addChild(deleteNode)
        
        
        setupKi()
        firstleaf()
        setupLeaf0()
        setupLeaf()
        setupLeaf2()
        setupBean()
        setupLabel()
    }
    
    
    //画面をタップした時に呼ばれるメソッド
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Tap")
        
        if play == 0 {
            return
        }
        if play == 2 {
            
            point = 0
            health = 10
            scrollCount = 0
            leafNo = 0
            kiNo = 0
            deletecount = 0
            deleteNo = 0
            removeAllChildren()
            
            play = 1
            print("Start")
            //重力を設定
            physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.8)
            physicsWorld.contactDelegate = self
            
            
            //背景色を設定
            backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1)
            backScreenNode = SKSpriteNode()
            backScreenNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            backScreenNode.physicsBody = SKPhysicsBody(circleOfRadius: 0.1)
            backScreenNode.physicsBody?.mass = 0.07
            backScreenNode.physicsBody?.isDynamic = true
            backScreenNode.physicsBody?.allowsRotation = false
            backScreenNode.physicsBody?.linearDamping = 0.3
            backScreenNode.physicsBody?.categoryBitMask = backScreenCategory
            backScreenNode.physicsBody?.contactTestBitMask = deleteCategory
            backScreenNode.physicsBody?.collisionBitMask = mameCategory
            backScreenNode.name = "BackScreen"
            addChild(backScreenNode)
            
            
            deleteNode = SKNode()
            deleteNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 10)
            deleteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
            deleteNode.physicsBody?.categoryBitMask = deleteCategory
            deleteNode.physicsBody?.contactTestBitMask = kiCategory | leafCategory
            deleteNode.physicsBody?.collisionBitMask = mameCategory
            deleteNode.physicsBody?.isDynamic = false
            deleteNode.name = "delete"
            addChild(deleteNode)
            
            
            setupKi()
            firstleaf()
            setupLeaf0()
            setupLeaf()
            setupLeaf2()
            setupBean()
            setupLabel()
        }
        
         //複数本の指でタッチした場合も想定されるので、その中から指一本分の座標データを取得
        if let touch = touches.first{
            //スクリーン上の座標データをlocationNodeメソッドでシーン上での座標に変換
            let location = touch.location(in: self)
            let action = SKAction.moveTo(x: location.x, duration:1.0)
            mame.run(action)
        }
        
    }
    
     //ドラッグ時
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: self)
            let action = SKAction.moveTo(x: location.x, duration: 1.0)
            self.mame?.run(action)
        }
    }
    
    
    
    func setupBean(){
        //まめくんの画像を読み込む
        let mameTexture = SKTexture(imageNamed: "Bean")
        mameTexture.filteringMode = SKTextureFilteringMode.linear
        
        
        //スプライトを作成
        mame = SKSpriteNode(texture: mameTexture)
        mame.position = CGPoint(x: self.frame.size.width * 0.5, y: self.frame.size.height * 0.7)
        mame.zPosition = 200
        //物理演算を設定
        mame.physicsBody = SKPhysicsBody(circleOfRadius: mame.size.height / 2.0)
        mame.physicsBody?.mass = 100
        
        //衝突した時に回転させる
        mame.physicsBody?.allowsRotation = true
        //重力に影響されない
        mame.physicsBody?.affectedByGravity = false
        mame.name = "mame"
        
        //衝突のカテゴリー設定
        mame.physicsBody?.categoryBitMask = mameCategory
        //mame.physicsBody?.collisionBitMask = leafCategory //当たった時に跳ね返る相手
        //mame.physicsBody?.contactTestBitMask = leafCategory //当たった時にdidBeginContactを呼び出す
        
        
        
        //スプライトを追加する
        addChild(mame)
        
    }
    
    func setupLeaf(){
        leafNo = leafNo + 1.0
        //葉の画像を読み込む
        let leafTexture = SKTexture(imageNamed: "Leaf_1")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        let leafNumber = 1.0 + CGFloat(arc4random_uniform(3))
        stride(from: 0.0, to: leafNumber, by: 1.0).forEach { i in
        //テクスチャを指定してスプライトを作成する
        Leaf = SKSpriteNode(texture: leafTexture)
        
        let random_x = 0.2 + CGFloat(arc4random_uniform(3)) * 0.1
        let random_y = CGFloat(arc4random_uniform(10)) * 0.1

        //スプライトの位置を指定する
        print(random_x)
        print(random_y)
        Leaf.position = CGPoint(x: self.frame.size.width * random_x, y: -scrollCount * ki.size.height - self.frame.size.height * random_y - self.frame.size.height + self.frame.size.height * i)
        Leaf.zPosition = 100
        
        //物理演算を設定
        Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width / 2, height: leafTexture.size().height / 10))
        Leaf.physicsBody?.categoryBitMask = leafCategory
        Leaf.physicsBody?.contactTestBitMask = mameCategory
        Leaf.physicsBody?.collisionBitMask = leafCategory
        
        
        //衝突の時に動かないようにする
        Leaf.physicsBody?.isDynamic = true
        //衝突の時に回らないようにする
        Leaf.physicsBody?.allowsRotation = false
        //質量を１に設定(木と同じ)
        Leaf.physicsBody?.mass = 0.0001
        Leaf.name = "leaf\(leafNo)"
        
        
        //親ノードにピン留
        Leaf.physicsBody?.pinned = true
        
        
        //スプライトを追加する
        backScreenNode.addChild(Leaf)
        }
        
        
    }
    
    func setupLeaf0(){
        leafNo = leafNo + 1.0
        //葉の画像を読み込む
        let leafTexture = SKTexture(imageNamed: "Leaf_0")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        let leafNumber = 1.0 + CGFloat(arc4random_uniform(3))
        stride(from: 0.0, to: leafNumber, by: 1.0).forEach { i in
            //テクスチャを指定してスプライトを作成する
            Leaf = SKSpriteNode(texture: leafTexture)
            
            let random_x = 0.2 + CGFloat(arc4random_uniform(3)) * 0.1
            let random_y = CGFloat(arc4random_uniform(10)) * 0.1
            
            //スプライトの位置を指定する
            print(random_x)
            print(random_y)
            Leaf.position = CGPoint(x: self.frame.size.width * random_x - (self.frame.size.width / 1.7), y: -scrollCount * ki.size.height - self.frame.size.height * random_y - self.frame.size.height + self.frame.size.height * i)
            Leaf.zPosition = 100
            
            //物理演算を設定
            Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width / 2, height: leafTexture.size().height / 10))
            Leaf.physicsBody?.categoryBitMask = leafCategory
            Leaf.physicsBody?.contactTestBitMask = mameCategory
            Leaf.physicsBody?.collisionBitMask = leafCategory
            
            
            //衝突の時に動かないようにする
            Leaf.physicsBody?.isDynamic = true
            //衝突の時に回らないようにする
            Leaf.physicsBody?.allowsRotation = false
            //質量を１に設定(木と同じ)
            Leaf.physicsBody?.mass = 0.0001
            Leaf.name = "leaf\(leafNo)"
            
            
            //親ノードにピン留
            Leaf.physicsBody?.pinned = true
            
            
            //スプライトを追加する
            backScreenNode.addChild(Leaf)
        }
        
        
    }
    
    func setupLeaf2(){
        leafNo = leafNo + 1.0
        //葉の画像を読み込む
        let leafTexture = SKTexture(imageNamed: "Leaf_2")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        let leafNumber = 1.0 + CGFloat(arc4random_uniform(3))
        stride(from: 0.0, to: leafNumber, by: 1.0).forEach { i in
            //テクスチャを指定してスプライトを作成する
            Leaf = SKSpriteNode(texture: leafTexture)
            
            let random_x = 0.0 + CGFloat(arc4random_uniform(1)) * 0.0
            let random_y = CGFloat(arc4random_uniform(10)) * 0.1
            
            //スプライトの位置を指定する
            print(random_x)
            print(random_y)
            Leaf.position = CGPoint(x: self.frame.size.width * random_x, y: -scrollCount * ki.size.height - self.frame.size.height * random_y - self.frame.size.height + self.frame.size.height * i)
            Leaf.zPosition = 100
            
            //物理演算を設定
            Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width / 2, height: leafTexture.size().height / 10))
            Leaf.physicsBody?.categoryBitMask = leafCategory
            Leaf.physicsBody?.contactTestBitMask = mameCategory
            Leaf.physicsBody?.collisionBitMask = leafCategory
            
            
            //衝突の時に動かないようにする
            Leaf.physicsBody?.isDynamic = true
            //衝突の時に回らないようにする
            Leaf.physicsBody?.allowsRotation = false
            //質量を１に設定(木と同じ)
            Leaf.physicsBody?.mass = 0.0001
            Leaf.name = "leaf2-\(leafNo)"
            
            
            //親ノードにピン留
            Leaf.physicsBody?.pinned = true
            
            
            //スプライトを追加する
            backScreenNode.addChild(Leaf)
        }
        
        
    }
    
     func firstleaf(){ //初期位置固定の葉
        let leafTexture = SKTexture(imageNamed: "Leaf_2")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        //テクスチャを指定してスプライトを作成する
        Leaf = SKSpriteNode(texture: leafTexture)
        Leaf.position = CGPoint(x: 0.0, y: 0.0)
        Leaf.zPosition = 100
        
        //物理演算を設定
        Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width / 0.7, height: leafTexture.size().height / 10))
        Leaf.physicsBody?.categoryBitMask = leafCategory
        Leaf.physicsBody?.contactTestBitMask = mameCategory
        
        
        //衝突の時に動かないようにする
        Leaf.physicsBody?.isDynamic = true
        //衝突の時に回らないようにする
        Leaf.physicsBody?.allowsRotation = false
        //質量を１に設定(木と同じ)
        Leaf.physicsBody?.mass = 0.0001
        Leaf.name = "leaf!!!"
        
        
        //親ノードにピン留
        Leaf.physicsBody?.pinned = true
        
        
        //スプライトを追加する
        backScreenNode.addChild(Leaf)
    }
    
    
    

    
    func setupKi(){
        kiNo = kiNo + 1.0
        
        //豆の木の画像を読み込む
        let kiTexture = SKTexture(imageNamed: "mamenoki")
        kiTexture.filteringMode = SKTextureFilteringMode.nearest
        
        //必要な枚数を計算
        let needNumber = 2.0 + (frame.size.height / kiTexture.size().height)
        
        //スプライトを作成
        stride(from: 0.0, to: needNumber, by: 1.0).forEach { i in
            ki = SKSpriteNode(texture: kiTexture)
            ki.position = CGPoint(x: 0.0, y: -scrollCount * ki.size.height)
            ki.zPosition = -100
            scrollCount = scrollCount + 1
            //物理演算を設定
            ki.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.0001, height: 0.0001))
            
            //質量を設定(葉と同じ)
            ki.physicsBody?.mass = 0.00001
            ki.physicsBody?.allowsRotation = false //回転しないようにする
            ki.physicsBody?.pinned = true
            ki.physicsBody?.categoryBitMask = self.kiCategory
            ki.physicsBody?.collisionBitMask = self.kiCategory
            ki.name = "ki\(kiNo)"
            
            backScreenNode.addChild(ki)
            
            //次の画面を用意するための判定
            scrollNode = SKNode()
            //scrollNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            scrollNode.position = CGPoint(x: 0.0, y: -scrollCount * ki.size.height - (ki.size.height * 0.25))
            scrollNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width * 2, height: 1.0))
            scrollNode.physicsBody?.categoryBitMask = self.scrollCategory
            scrollNode.physicsBody?.contactTestBitMask = self.mameCategory
            scrollNode.physicsBody?.collisionBitMask = self.kiCategory
            scrollNode.physicsBody?.mass = 0.00001
            scrollNode.name = "scroll\(scrollCount)"
            
            //ピン留
            scrollNode.physicsBody?.pinned = true
            
            //シーンにスプライトを追加
            backScreenNode.addChild(scrollNode)

        }

        
        
        
    }
    
    func setKi(){
        kiNo = kiNo + 1.0
        
        //豆の木の画像を読み込む
        let kiTexture = SKTexture(imageNamed: "mamenoki")
        kiTexture.filteringMode = SKTextureFilteringMode.nearest
        
        //スプライトを作成
            ki = SKSpriteNode(texture: kiTexture)
            ki.position = CGPoint(x: 0.0, y: -scrollCount * ki.size.height)
            ki.zPosition = -100
            scrollCount = scrollCount + 1
            //物理演算を設定
            ki.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.0001, height: 0.0001))
            
            //質量を設定(葉と同じ)
            ki.physicsBody?.mass = 0.00001
            ki.physicsBody?.allowsRotation = false //回転しないようにする
            ki.physicsBody?.pinned = true
            ki.physicsBody?.categoryBitMask = self.kiCategory
            ki.name = "ki\(kiNo)"
            
            backScreenNode.addChild(ki)
            
            //次の画面を用意するための判定
            scrollNode = SKNode()
            //scrollNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            scrollNode.position = CGPoint(x: 0.0, y: -scrollCount * ki.size.height - (ki.size.height * 0.25))
            scrollNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width * 2, height: 1.0))
            scrollNode.physicsBody?.categoryBitMask = self.scrollCategory
            scrollNode.physicsBody?.contactTestBitMask = self.mameCategory
            scrollNode.physicsBody?.mass = 0.00001
            scrollNode.name = "scroll\(scrollCount)"
            
            //ピン留
            scrollNode.physicsBody?.pinned = true
            
            //シーンにスプライトを追加
            backScreenNode.addChild(scrollNode)
        
    }
    
    
    func mameJump(){
        //スクロールの速度をゼロにする
        backScreenNode.physicsBody?.velocity = CGVector.zero

        
        backScreenNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -30.0))

    }
    
    func setupLabel(){
        health = 10
        healthLabelNode = SKLabelNode()
        healthLabelNode.fontColor = UIColor.black
        healthLabelNode.position = CGPoint(x: 10, y: self.frame.size.height - 30)
        healthLabelNode.zPosition = 500
        healthLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        healthLabelNode.text = "\(health)"
        
        pointLabelNode = SKLabelNode()
        pointLabelNode.fontColor = UIColor.black
        pointLabelNode.position = CGPoint(x: 10, y: self.frame.size.height - 60)
        pointLabelNode.zPosition = 500
        pointLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        pointLabelNode.text = "\(point)m"
        
        bestScoreLabelNode = SKLabelNode()
        bestScoreLabelNode.fontColor = UIColor.black
        bestScoreLabelNode.position = CGPoint(x: 10, y: self.frame.size.height - 90)
        bestScoreLabelNode.zPosition = 500
        bestScoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        let bestScore = userDefaults.integer(forKey: "BEST")
        bestScoreLabelNode.text = "Best:\(bestScore)m"
        
        self.addChild(healthLabelNode)
        self.addChild(pointLabelNode)
        self.addChild(bestScoreLabelNode)
    }
    
    //SKPhysicsContactDelegateのメソッド。衝突した時に呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        let centering = SKAction.moveTo(x: self.frame.size.width / 2, duration: 0.0)
        backScreenNode.run(centering)

        print("bodyA:\(contact.bodyA)")
        print("bodyB:\(contact.bodyB)")
        
        if health == 0 {
            backScreenNode.physicsBody?.velocity = CGVector.zero
            backScreenNode.physicsBody?.isDynamic = false
            physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
            physicsWorld.contactDelegate = self
            mame.physicsBody?.affectedByGravity = true
            play = 2
        }
        if play != 1 {
            return
        }else if (contact.bodyA.categoryBitMask & deleteCategory) == deleteCategory || (contact.bodyB.categoryBitMask & deleteCategory) == deleteCategory{ //削除判定
            
            print("contant!_bodyA:\(String(describing: contact.bodyA.node?.name))_bodyB:\(String(describing: contact.bodyB.node?.name))")
            if (contact.bodyA.categoryBitMask & deleteCategory) == deleteCategory{
                let deletename = (contact.bodyB.node?.name)!
                if deletename == "leaf!!!" {
                    deleteNode.removeFromParent()
                    deleteNode = SKNode()
                    deleteNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 8)
                    deleteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                    deleteNode.physicsBody?.categoryBitMask = deleteCategory
                    deleteNode.physicsBody?.contactTestBitMask = kiCategory | leafCategory
                    deleteNode.physicsBody?.collisionBitMask = mameCategory
                    deleteNode.physicsBody?.isDynamic = false
                    deleteNode.name = "delete"
                    addChild(deleteNode)
                    print("deleteNodemoving")
                }
                backScreenNode.childNode(withName: deletename)?.removeFromParent()
            }else{
                let deletename = (contact.bodyA.node?.name)!
                if deletename == "leaf!!!" {
                    deleteNode.removeFromParent()
                    deleteNode = SKNode()
                    deleteNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 8)
                    deleteNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                    deleteNode.physicsBody?.categoryBitMask = deleteCategory
                    deleteNode.physicsBody?.contactTestBitMask = kiCategory | leafCategory
                    deleteNode.physicsBody?.collisionBitMask = mameCategory
                    deleteNode.physicsBody?.isDynamic = false
                    deleteNode.name = "delete"
                    addChild(deleteNode)
                    print("deleteNodemoving")
                }
                backScreenNode.childNode(withName: deletename)?.removeFromParent()
            }
        }else if (contact.bodyA.categoryBitMask & scrollCategory) == scrollCategory || (contact.bodyB.categoryBitMask & scrollCategory) == scrollCategory { //まめくんがスクロール判定を通過した時
            print("contact:scroll")
            print("pointUp")
            point += 1
            pointLabelNode.text = "\(point)m"
            var bestScore = userDefaults.integer(forKey: "BEST")
            if point > bestScore {
                bestScore = point
                bestScoreLabelNode.text = "Best:\(bestScore)m"
                userDefaults.set(bestScore, forKey: "BEST")
                userDefaults.synchronize()
            }
            
            if (contact.bodyA.categoryBitMask & scrollCategory) == scrollCategory { //スクロール判定を消す
                contact.bodyA.node?.removeFromParent()
                contact.bodyA.node?.removeAllChildren()
                setKi()
                setupLeaf()
                setupLeaf0()
                setupLeaf2()
            }else{
                contact.bodyB.node?.removeFromParent()
                contact.bodyB.node?.removeAllChildren()
                setKi()
                setupLeaf()
                setupLeaf0()
                setupLeaf2()
            }
        }else if (contact.bodyA.categoryBitMask & leafCategory) == leafCategory || (contact.bodyB.categoryBitMask & leafCategory) == leafCategory { //まめくんが葉と衝突した時
            print("contact:leaf")
            mameJump()
            health -= 1
            healthLabelNode.text = "\(health)"
        }
            
    }
}
