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
    var leafNode:SKNode!
    
    
    //衝突判定カテゴリー
    let mameCategory: UInt32 = 1 << 0
    let leafCategory: UInt32 = 1 << 1
    
    
    //SKView上にシーンが表示された時に呼ばれるメソッド
    override func didMove(to view: SKView) {
        print("Start")
        //重力を設定
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        
        leafNode = SKNode()
        
        //背景色を設定
        backgroundColor = UIColor(colorLiteralRed: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        setupLeaf()
        setupBean()
        setupKi()
    }
    
    //画面をタップした時に呼ばれるメソッド
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Tap")
        mameJump()
    }
    
    
    
    func setupBean(){
        //まめくんの画像を読み込む
        let mameTexture = SKTexture(imageNamed: "Bean")
        mameTexture.filteringMode = SKTextureFilteringMode.linear
        
        //テクスチャを指定してスプライトを作成する
        mame = SKSpriteNode(texture: mameTexture)
        
        //スプライトの位置を指定する
        mame.position = CGPoint(x: size.width / 2, y: size.height / 2)
        mame.zPosition = 100
        
        //物理演算を設定
        mame.physicsBody = SKPhysicsBody(circleOfRadius: mame.size.height / 2.0)
        //衝突カテゴリ設定
        mame.physicsBody?.categoryBitMask = mameCategory
        //跳ね返る相手
        mame.physicsBody?.collisionBitMask = leafCategory
        //当たった時にdidBeginContactを呼び出す
        mame.physicsBody?.contactTestBitMask = leafCategory
        
        //シーンにスプライトを追加する
        addChild(mame)
        
    }
    
    func setupLeaf(){
        //葉の画像を読み込む
        let leafTexture = SKTexture(imageNamed: "Leaf_1")
        leafTexture.filteringMode = SKTextureFilteringMode.linear
        
        //テクスチャを指定してスプライトを作成する
        let Leaf = SKSpriteNode(texture: leafTexture)
        
        //スプライトの位置を指定する
        Leaf.position = CGPoint(x: size.width / 2, y: size.height / 3)
        
        //物理演算を設定
        Leaf.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: leafTexture.size().width, height: leafTexture.size().height / 10))
        Leaf.physicsBody?.categoryBitMask = leafCategory
        Leaf.physicsBody?.contactTestBitMask = mameCategory
        
        
        //衝突の時に動かないようにする
        Leaf.physicsBody?.isDynamic = false
        
        //スプライトを追加する
        
        leafNode.addChild(Leaf)
    }
    
    func setupKi(){
        //豆の木の画像を読み込む
        let kiTexture = SKTexture(imageNamed: "mamenoki")
        kiTexture.filteringMode = SKTextureFilteringMode.nearest
        
        //スプライトを作成
        let ki = SKSpriteNode(texture: kiTexture)
        
        //スプライトの位置を指定する
        ki.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ki.zPosition = -100
        
        //シーンにスプライトを追加
        addChild(ki)
        
    }
    
    func mameJump(){
        //まめくんの速度をゼロにする
        mame.physicsBody?.velocity = CGVector.zero
        
        //まめくんに縦方向の力を与える
        mame.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 25.0))
    }
    
    
    //SKPhysicsContactDelegateのメソッド。衝突した時に呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        
        if (contact.bodyA.categoryBitMask & leafCategory) == leafCategory || (contact.bodyB.categoryBitMask & leafCategory) == leafCategory {
            mameJump()
        }
            
            
            
        }
    
}
