package com.adserversoft.flexfuse.client.view.component.dnd {
import mx.containers.Panel;
import mx.containers.VBox;
import mx.controls.Button;

public class AdPlacesPanel extends Panel {
    public var leftVB:VBox;
    public var addAdPlaceB:Button;


    public function getAdPlaceViewByUid(uid:String):AdPlaceView {
        for (var i:int = 0; i < leftVB.getChildren().length; i++) {
            if (leftVB.getChildAt(i) is AdPlaceView) {
                var bv:AdPlaceView = leftVB.getChildAt(i) as AdPlaceView;
                if (bv.adPlaceUid == uid)return bv;
            }
        }
        return null;
    }

    public function getBannerViewByUid(uid:String):BannerView {
        for (var i:int = 0; i < leftVB.getChildren().length; i++) {
            if (leftVB.getChildAt(i) is AdPlaceView) {
                var av:AdPlaceView = leftVB.getChildAt(i) as AdPlaceView;
                var p:Paddock = av.paddock;
                for (var k:int = 0; k < p.contentVB.getChildren().length; k++) {
                    if (p.contentVB.getChildAt(k) is BannerView) {
                        var bv:BannerView = p.contentVB.getChildAt(k) as BannerView;
                        if (bv.bannerUid == uid)return bv;
                    }
                }
            }
        }
        return null;
    }

    public function  removeAllAdPlaces():void {
        for (var i:int = leftVB.getChildren().length - 1; i >= 0; i--) {
            if (leftVB.getChildAt(i) is AdPlaceView || leftVB.getChildAt(i) is Paddock || leftVB.getChildAt(i) is BannerView || leftVB.getChildAt(i) is PlaceHolder) {
                leftVB.removeChild(leftVB.getChildAt(i));
            }
        }
    }
}
}