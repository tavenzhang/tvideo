//
//  CommonView.swift
//  TVideo
//
//  Created by  on 16/5/31.
//  Copyright © 2016年 . All rights reserved.
//

import Foundation
import UIKit


class BaseTViewControl:UIViewController {


    
    deinit{
         NSNotificationCenter.defaultCenter().removeObserver(self);
    }
}