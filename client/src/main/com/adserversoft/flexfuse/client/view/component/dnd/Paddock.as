package com.adserversoft.flexfuse.client.view.component.dnd {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.ObjectEvent;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.HRule;
import mx.core.IUIComponent;
import mx.core.ScrollPolicy;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.managers.DragManager;
import mx.states.State;

[Bindable]
public class Paddock extends VBox {
    public var dndWizard:DragNDropWizard;
    public var bannersAddedState:State;
    public var dragHereState:State;
    public var contentVB:AutosizeVBox;
    public var headersHB:HBox;
    public var dragMessageHB:HBox;
    public var headersVB:VBox;
    public var contentBottomLineHR:HRule;
    public var changeWatcher:Boolean;

    public function Paddock() {
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(event:Event):void {
        var i:int;

        states = new Array();
        states.push(bannersAddedState);
        states.push(dragHereState);
        currentState = dragHereState.name;

        percentWidth = 100;
        setStyle("verticalGap", "0");
        setStyle("backgroundColor", "#f7f7f7");
        setStyle("verticalAlign", "bottom");
        setStyle("horizontalAlign", "center");

        verticalScrollPolicy = ScrollPolicy.OFF;
        horizontalScrollPolicy = ScrollPolicy.OFF;

        addEventListener(DragEvent.DRAG_ENTER, doDragEnter);
        addEventListener(DragEvent.DRAG_EXIT, doDragExit);
        addEventListener(DragEvent.DRAG_DROP, doDragDrop);

        var maxBannerPriority:int = 0;
        var adPlaceView:AdPlaceView = AdPlaceView(parent);
        var adPlace:AdPlaceVO = dndWizard.adPlaces.getValue(adPlaceView.adPlaceUid);
        var assignedBanners:ArrayCollection = adPlace.banners;
        for (i = 0; i < assignedBanners.length; i++) {
            if ((assignedBanners.getItemAt(i) as BannerVO).priority > maxBannerPriority) {
                maxBannerPriority = (assignedBanners.getItemAt(i) as BannerVO).priority;
            }
            addBannerFromState(assignedBanners.getItemAt(i) as BannerVO);
        }

        refresh();
        changeWatcher = !changeWatcher;
        parent.removeChild(this);
    }

    private function doDragEnter(event:DragEvent):void {
        var dropPaddock:Paddock = Paddock(event.currentTarget);
        if (dropPaddock.hasBanners())return;
        var dropAdPlaceView:AdPlaceView = dropPaddock.parent as AdPlaceView;

        //can only drop banner if this ad place's ad format matches banner's ad format
        if (event.dragInitiator.parent is BannerView) {
            var draggedBannerView:BannerView = event.dragInitiator.parent as BannerView;
            var adPlace:AdPlaceVO = dndWizard.adPlaces.getValue(dropAdPlaceView.adPlaceUid);
            var banner:BannerVO = dndWizard.banners.getValue(draggedBannerView.bannerUid);
            if (banner.adFormat == adPlace.adFormat) {
                setColor(event, "#c7c7f7");
            }
        }
    }

    private function doDragExit(event:DragEvent):void {
        setColor(event, "#f7f7f7");
    }

    private function setColor(event:DragEvent, borderColor:String):void {
        if (event.dragInitiator.parent is BannerView) {
            var paddock:Paddock = event.currentTarget as Paddock;
            paddock.setStyle("backgroundColor", borderColor);
            DragManager.acceptDragDrop(IUIComponent(event.currentTarget));
        }
    }

    private function doDragDrop(event:DragEvent):void {
        var draggedBannerView:BannerView = event.dragInitiator.parent as BannerView;
        var dropPaddock:Paddock = event.currentTarget as Paddock;
        var dropAdPlaceView:AdPlaceView = dropPaddock.parent as AdPlaceView;
        var newBannerView:BannerView = draggedBannerView;
        var bannerProxy:BannerProxy = ApplicationFacade.getInstance().retrieveProxy(BannerProxy.NAME) as BannerProxy;

        //dragging from another paddock
        if (draggedBannerView.parent.parent is Paddock) {//if dragging from another paddock
            var draggedPaddock:Paddock = draggedBannerView.parent.parent as Paddock;
            draggedPaddock.contentVB.removeChild(draggedBannerView);

            //dragging from the banners panel
        } else {
            newBannerView = new BannerViewUI();
            newBannerView.dndWizard = dndWizard;
            //creating new banner vo using clone
            var newBanner:BannerVO = BannerVO(dndWizard.banners.getValue(draggedBannerView.bannerUid)).clone();
            newBanner.views = 0;
            newBanner.clicks = 0;
            newBanner.displayOrder = 1;
            //generating new uid for this object and setting bindings
            newBanner.uid = ApplicationConstants.getNewUid();
            //            newBanner.adPlaceUid = dropAdPlaceView.adPlaceUid;
            newBanner.parentUid = draggedBannerView.bannerUid;

            newBannerView.bannerUid = newBanner.uid;
            bannerProxy.cloneUrlPatterns(draggedBannerView.bannerUid, newBanner.uid);
            bannerProxy.cloneDynamicParameter(draggedBannerView.bannerUid, newBanner.uid);
            bannerProxy.cloneReferrerPattern(draggedBannerView.bannerUid, newBanner.uid);
            bannerProxy.cloneIpPattern(draggedBannerView.bannerUid, newBanner.uid);
            dndWizard.banners.put(newBanner.uid, newBanner);

            //changing banner's state to display different columns
            newBannerView.currentStateName = BannerView.ASSIGNED_STATE;

        }

        //adding banner to this paddock
        dropPaddock.contentVB.addChild(new PlaceHolder(dndWizard));
        dropPaddock.contentVB.addChild(newBannerView);
        dropPaddock.contentVB.addChild(new PlaceHolder(dndWizard));

        BannerVO(dndWizard.banners.getValue(newBannerView.bannerUid)).adPlaceUid = dropAdPlaceView.adPlaceUid;

        dropPaddock.setColor(event, "#f7f7f7");

        //we don't need to listen on the paddock after the first drop, banner and place holders will serve as glue now
        dropPaddock.removeEventListener(DragEvent.DRAG_ENTER, doDragEnter);
        dropPaddock.removeEventListener(DragEvent.DRAG_EXIT, doDragExit);
        dropPaddock.removeEventListener(DragEvent.DRAG_DROP, doDragDrop);

        if (draggedPaddock != null)draggedPaddock.refresh();
        dropPaddock.refresh();
        draggedBannerView.changeWatcher = !draggedBannerView.changeWatcher;
        newBannerView.changeWatcher = !newBannerView.changeWatcher;
        dropPaddock.changeWatcher = !dropPaddock.changeWatcher;

        //notifying of the state change
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.BANNER_CHANGE, newBannerView));
    }

    private function hasBanners():Boolean {
        for (var i:int = 0; i < contentVB.getChildren().length; i++) {
            if (contentVB.getChildAt(i) is BannerView)return true;
        }
        return false;
    }

    public function refresh():void {
        if (hasBanners()) {
            currentState = bannersAddedState.name;
        } else {
            currentState = dragHereState.name;
        }

        if (currentState == dragHereState.name) {
            addEventListener(DragEvent.DRAG_ENTER, doDragEnter);
            addEventListener(DragEvent.DRAG_EXIT, doDragExit);
            addEventListener(DragEvent.DRAG_DROP, doDragDrop);
            contentVB.removeAllChildren();
        } else {

            //inserting place holders at the bottom and top if necessary
            var placeHolder:PlaceHolder;
            if (!(contentVB.getChildAt(0) is PlaceHolder)) {
                placeHolder = new PlaceHolder(dndWizard);
                contentVB.addChildAt(placeHolder, 0);
            }
            if (!(contentVB.getChildAt(contentVB.getChildren().length - 1) is PlaceHolder)) {
                placeHolder = new PlaceHolder(dndWizard);
                contentVB.addChildAt(placeHolder, contentVB.getChildren().length);
            }

            //removing two place holders in a row, refreshing banners
            try {
                for (var i:int = 0; i < contentVB.getChildren().length; i++) {
                    if (contentVB.getChildAt(i) is PlaceHolder && contentVB.getChildAt(i + 1) is PlaceHolder) {
                        contentVB.removeChildAt(i);
                    } else if (contentVB.getChildAt(i) is BannerView) {
                        BannerView(contentVB.getChildAt(i)).refresh();
                    }
                }
            } catch(event:*) {
            }

            //updating priorities
            var priority:int = 1;
            for (var k:int = 1; k < contentVB.getChildren().length; k++) {//starting from 1 because it should be a place holder
                if (contentVB.getChildAt(k) is BannerView) {
                    BannerVO(dndWizard.banners.getValue(BannerView(contentVB.getChildAt(k)).bannerUid)).priority = priority;
                } else {
                    ++priority;
                }
            }

            var bannerProxy:BannerProxy = ApplicationFacade.getInstance().retrieveProxy(BannerProxy.NAME) as BannerProxy;
            //            bannerProxy.debugBanners();

            //updating traffic shares
            for (k = 1; k < contentVB.getChildren().length; k++) {//starting from 1 because it should be a place holder
                if (contentVB.getChildAt(k) is BannerView) {
                    var banner:BannerVO = BannerVO(dndWizard.banners.getValue(BannerView(contentVB.getChildAt(k)).bannerUid));
                    var groupCount:int = bannerProxy.getGroupCountByPriority(banner.adPlaceUid, banner.priority);
                    banner.trafficShare = int(100 - (100 / groupCount) * (groupCount - 1));
                }
            }
            //adjusting last traffic share if exceeding 100
            for (k = 1; k < contentVB.getChildren().length; k++) {//starting from 1 because it should be a place holder
                if (contentVB.getChildAt(k) is BannerView) {
                    banner = BannerVO(dndWizard.banners.getValue(BannerView(contentVB.getChildAt(k)).bannerUid));
                }
            }
            if (banner != null) {
                var totalTrafficShare:int = bannerProxy.getTotalTrafficShare(banner.adPlaceUid, banner.priority);
                if (totalTrafficShare > 100) {
                    banner.trafficShare -= totalTrafficShare - 100;
                }
                if (totalTrafficShare < 100) {
                    banner.trafficShare += 100 - totalTrafficShare;
                }
            }


        }


        callLater(resizeContent);

    }

    private function resizeContent():void {
        contentVB.invalidateSize();
        contentVB.validateNow();
    }

    /**
     * Adds banner to paddock, used on state load
     * @param banner
     */
    public function addBannerFromState(banner:BannerVO):void {
        currentState = bannersAddedState.name;
        if (contentVB.getChildren().length > 0) {
            var b:BannerVO = dndWizard.banners.getValue((contentVB.getChildAt(contentVB.getChildren().length - 2) as BannerView).bannerUid) as BannerVO;
            if (b.priority != banner.priority) {
                var placeHolder:PlaceHolder = new PlaceHolder(dndWizard);
                contentVB.addChildAt(placeHolder, contentVB.getChildren().length);
            }
        } else {
            var placeHolder1:PlaceHolder = new PlaceHolder(dndWizard);
            contentVB.addChildAt(placeHolder1, 0);
            var placeHolder2:PlaceHolder = new PlaceHolder(dndWizard);
            contentVB.addChildAt(placeHolder2, 0);
        }
        var newBannerView:BannerViewUI = new BannerViewUI();
        newBannerView.dndWizard = dndWizard;
        newBannerView.bannerUid = banner.uid;
        newBannerView.currentStateName = BannerView.ASSIGNED_STATE;

        contentVB.addChildAt(newBannerView, contentVB.getChildren().length - 1);
        refresh();
        newBannerView.refresh();
    }

}
}