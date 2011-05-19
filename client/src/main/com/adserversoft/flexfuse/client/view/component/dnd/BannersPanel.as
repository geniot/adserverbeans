package com.adserversoft.flexfuse.client.view.component.dnd {
import mx.containers.Panel;
import mx.containers.VBox;
import mx.controls.Button;

public class BannersPanel extends Panel {
    public var rightVB:VBox;
    public var addBannerB:Button;


    public function getBannerViewByUid(uid:String):BannerView {
        for (var i:int = 0; i < rightVB.getChildren().length; i++) {
            if (rightVB.getChildAt(i) is BannerView) {
                var bv:BannerView = rightVB.getChildAt(i) as BannerView;
                if (bv.bannerUid == uid)return bv;
            }
        }
        return null;
    }

    public function removeAllBanners():void {
        for (var i:int = rightVB.getChildren().length - 1; i >= 0; i--) {
            if (rightVB.getChildAt(i) is BannerView) {
                rightVB.removeChild(rightVB.getChildAt(i));
            }
        }
    }
}
}