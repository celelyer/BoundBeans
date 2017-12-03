//
//  GameScene.swift
//  BoundBeans
//
//  Created by セロラー on 2017/11/27.
//  Copyright © 2017年 mikiya.tadano. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mame:SKSpriteNode!
    var backScreenNode:SKSpriteNode!
    var Leaf:SKSpriteNode!
    var ki:SKSpriteNode!
    var scrollNode:SKNode!
    
    //衝突判定カテゴリー
    let mameCategory: UInt32 = 1 << 0
    let leafCategory: UInt32 = 1 << 1
    let scrollCategory: UInt32 = 1 << 2
    
    
    //SKView上にシーンが表示された時に呼ばれるメソッド
    override func didMove(to view: SKView) {
        print("Start")
        //重力を設定
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.8)
        physicsWorld.contactDelegate = self
        
        backScreenNode = SKSpriteNode()
        backScreenNode.physicsBody = SKPhysicsBody()
        addChild(backScreenNode)
        
        //背景色を設定
        //backgroundColor = UIColor(colorLiteralRed: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        setupKi()
        setupLeaf()
        setupBean()
        
    }
    
    //画面をタップした時に呼ばれるメソッド
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Tap")
        mameJump()
        
        
        
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
        
        //物理演算を設定
        mame.physicsBody = SKPhysicsBody(circleOfRadius: mame.size.height / 2.0)
        
        //衝突した時に回転させる
        mame.physicsBody?.allowsRotation = true
        //重力に影響されない
        mame.physicsBody?.affectedByGravity = false
        
        
        //衝突のカテゴリー設定
        mame.physicsBody?.categoryBitMask = mameCategory
        mame.physicsBody?.collisionBitMask = leafCategory //当たった時に跳ね返る相手
        mame.physicsBody?.contactTestBitMask = leafCategory //当たった時にdidBeginContactを呼び出す
        
        
        
        //スプライトを追加する
        addChild(mame)
        
    }
    
    func setupLeaf(){
        //葉の画像を読み込む
        let leafTexture = SKTexture(imageNamed: "Leaf_1")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        //テクスチャを指定してスプライトを作成する
        Leaf = SKSpriteNode(texture: leafTexture)
        
        //スプライトの位置を指定する
        Leaf.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 3)
        
        //物理演算を設定
        Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width, height: leafTexture.size().height / 10))
        Leaf.physicsBody?.categoryBitMask = leafCategory
        Leaf.physicsBody?.contactTestBitMask = mameCategory
        
        
        //衝突の時に動かないようにする
        Leaf.physicsBody?.isDynamic = true
        //衝突の時に回らないようにする
        Leaf.physicsBody?.allowsRotation = true
        //質量を１に設定(木と同じ)
        Leaf.physicsBody?.mass = 0.07
        
        //親ノードにピン留
        Leaf.physicsBody?.pinned = false
        
        
        //スプライトを追加する
        
        backScreenNode.addChild(Leaf)
    }
    
    func setLeaf(){ //画面外に設置する
        //葉の画像を読み込む
        let leafTexture = SKTexture(imageNamed: "Leaf_1")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        //テクスチャを指定してスプライトを作成する
        Leaf = SKSpriteNode(texture: leafTexture)
        
        //スプライトの位置を指定する
        Leaf.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 3 - self.frame.size.height)
        
        //物理演算を設定
        Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width, height: leafTexture.size().height / 10))
        Leaf.physicsBody?.categoryBitMask = leafCategory
        Leaf.physicsBody?.contactTestBitMask = mameCategory
        
        
        //衝突の時に動かないようにする
        Leaf.physicsBody?.isDynamic = true
        //衝突の時に回らないようにする
        Leaf.physicsBody?.allowsRotation = true
        //質量を１に設定(木と同じ)
        Leaf.physicsBody?.mass = 0.07
        
        //親ノードにピン留
        Leaf.physicsBody?.pinned = false
        
        
        //スプライトを追加する
        
        backScreenNode.addChild(Leaf)
    }
    
    func setupKi(){
        //豆の木の画像を読み込む
        let kiTexture = SKTexture(imageNamed: "mamenoki")
        kiTexture.filteringMode = SKTextureFilteringMode.nearest
        
        //スプライトを作成
        ki = SKSpriteNode(texture: kiTexture)
        
        
        //スプライトの位置を指定する
        ki.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        ki.zPosition = -100
        
        //物理演算を設定
        ki.physicsBody = SKPhysicsBody(rectangleOf: kiTexture.size(), center: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height))
        //質量を設定(葉と同じ)
        ki.physicsBody?.mass = 0.07
        
        //次の画面を用意するための判定
        scrollNode = SKNode()
        scrollNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        scrollNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width * 2, height: 1.0))
        scrollNode.physicsBody?.categoryBitMask = self.scrollCategory
        scrollNode.physicsBody?.contactTestBitMask = self.mameCategory
        scrollNode.physicsBody?.mass = 0.07
        
        
        
        //シーンにスプライトを追加
        backScreenNode.addChild(ki)
        backScreenNode.addChild(scrollNode)
    }
    
    func setKi(){ //画面外に木を設置
        //豆の木の画像を読み込む
        let kiTexture = SKTexture(imageNamed: "mamenoki")
        kiTexture.filteringMode = SKTextureFilteringMode.nearest
        
        //スプライトを作成
        ki = SKSpriteNode(texture: kiTexture)
        
        
        //スプライトの位置を指定する
        ki.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2 - self.frame.size.height)
        ki.zPosition = -100
        
        //物理演算を設定
        ki.physicsBody = SKPhysicsBody(rectangleOf: kiTexture.size(), center: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height))
        //質量を設定(葉と同じ)
        ki.physicsBody?.mass = 0.07
        
        //次の画面を用意するための判定
        scrollNode = SKNode()
        scrollNode.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        scrollNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width * 2, height: 1.0))
        scrollNode.physicsBody?.categoryBitMask = self.scrollCategory
        scrollNode.physicsBody?.contactTestBitMask = self.mameCategory
        scrollNode.physicsBody?.mass = 0.07
        
        
        
        //シーンにスプライトを追加
        backScreenNode.addChild(ki)
        backScreenNode.addChild(scrollNode)
    }
    
    
    func mameJump(){
        //まめくんが跳ねないようにする
        mame.physicsBody?.velocity = CGVector.zero
        //まめくんがちょっと跳ねる初期の高さに戻る
        let goback_up = SKAction.moveTo(y: self.frame.height * 0.73, duration: 0.5)
        let goback_down = SKAction.moveTo(y: self.frame.height * 0.70, duration: 0.5)
        let goback = SKAction.sequence([goback_up, goback_down])
        self.mame?.run(goback)
        
        //スクロールの速度をゼロにする
        Leaf.physicsBody?.velocity = CGVector.zero
        ki.physicsBody?.velocity = CGVector.zero
        scrollNode.physicsBody?.velocity = CGVector.zero
        //スクロールに縦方向の力を与える
        Leaf.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -25.0))
        ki.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -25.5))
        scrollNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: -25.5))
    }
    
    
    //SKPhysicsContactDelegateのメソッド。衝突した時に呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        
        if (contact.bodyA.categoryBitMask & leafCategory) == leafCategory || (contact.bodyB.categoryBitMask & leafCategory) == leafCategory { //まめくんが葉と衝突した時
            mameJump()
        }else if (contact.bodyA.categoryBitMask & scrollCategory) == scrollCategory || (contact.bodyB.categoryBitMask & scrollCategory) == scrollCategory { //まめくんがスクロール判定を通過した時
            print("scroll")
            if (contact.bodyA.categoryBitMask & scrollCategory) == scrollCategory{ //スクロール判定を消す
                contact.bodyA.node?.removeFromParent()
            }else{
                contact.bodyB.node?.removeFromParent()
            }
        }
            
    }
    
}
