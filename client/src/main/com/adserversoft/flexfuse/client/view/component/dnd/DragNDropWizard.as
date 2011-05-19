package com.adserversoft.flexfuse.client.view.component.dnd {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.UploadProxy;
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.IDragNDropWizard;
import com.adserversoft.flexfuse.client.model.vo.IMap;
import com.adserversoft.flexfuse.client.model.vo.ObjectEvent;
import com.adserversoft.flexfuse.client.view.component.supertab.SuperTab;
import com.adserversoft.flexfuse.client.view.component.supertab.SuperTabEvent;
import com.adserversoft.flexfuse.client.view.component.supertab.SuperTabNavigator;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.containers.HDividedBox;
import mx.containers.Panel;
import mx.controls.Alert;
import mx.core.Container;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;

public class DragNDropWizard extends HDividedBox implements IDragNDropWizard {

    public static var ADD_BANNER_BTN_CLICK:String = "ADD_BANNER_BTN_CLICK";
    public static var PREVIEW_BANNER_BTN_CLICK:String = "PREVIEW_BANNER_BTN_CLICK";
    public static var EDIT_BANNER_BTN_CLICK:String = "EDIT_BANNER_BTN_CLICK";
    public static var REMOVE_BANNER_BTN_CLICK:String = "REMOVE_BANNER_BTN_CLICK";

    public static var ADD_AD_PLACE_BTN_CLICK:String = "ADD_AD_PLACE_BTN_CLICK";
    public static var GET_AD_TAG_AD_PLACE_BTN_CLICK:String = "GET_AD_TAG_AD_PLACE_BTN_CLICK";
    public static var REMOVE_AD_PLACE_BTN_CLICK:String = "REMOVE_AD_PLACE_BTN_CLICK";

    public static var BANNER_CHANGE:String = "BANNER_CHANGE";
    public static var BANNER_TRAFFIC_SHARE_INVALID:String = "BANNER_TRAFFIC_SHARE_INVALID";
    public static var BANNER_TRAFFIC_SHARE_VALID:String = "BANNER_TRAFFIC_SHARE_VALID";
    public static var AD_PLACE_CHANGE:String = "AD_PLACE_CHANGE";

    public static var TAB_LABEL_CHANGE:String = "TAB_LABEL_CHANGE";
    public static var REMOVE_BANNER_TAB:String = "REMOVE_BANNER_TAB";
    public static var REMOVE_AD_PLACE_TAB:String = "REMOVE_AD_PLACE_TAB";

    private static var counterAdvertiserTab:int = 1;
    private static var counterSiteTab:int = 1;
    private static var nameAdvertiserTab:String = "New Advertiser ";
    private static var nameSiteTab:String = "New Site ";
    public var bannersTabNavigator:SuperTabNavigator;
    public var adPlacesTabNavigator:SuperTabNavigator;

    public var hDividedBox:HDividedBox;
    private var selectedSuperTabNavigator:SuperTabNavigator;
    private var selectedTabIndex:Number;

    public var banners:IMap;
    public var adPlaces:IMap;

    public function DragNDropWizard() {
        super();
        if (UIComponent(this).initialized) {
            onCreationComplete(null);
        } else {
            UIComponent(this).addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
        }
    }

    private function onCreationComplete(event:Event):void {
        var adPlacesHeader:Panel = getPanel("Ad Places");
        adPlacesHeader.setStyle("color", 0xFFFFFF);
        hDividedBox.addChild(adPlacesHeader);
        adPlacesTabNavigator = getTabNavigator();
        adPlacesHeader.addChild(adPlacesTabNavigator);

        var bannersHeader:Panel = getPanel("Banners");
        bannersHeader.setStyle("color", 0xFFFFFF);
        hDividedBox.addChild(bannersHeader);
        bannersTabNavigator = getTabNavigator();
        bannersHeader.addChild(bannersTabNavigator);

        bannersTabNavigator.addTabB.addEventListener(MouseEvent.CLICK, onBannerTabAdd);
        adPlacesTabNavigator.addTabB.addEventListener(MouseEvent.CLICK, onAdPlacesTabAdd);
    }

    private function onBannerTabAdd(event:MouseEvent):void {
        var panel:BannersPanel = addBannerTab(DragNDropWizard.nameAdvertiserTab + DragNDropWizard.counterAdvertiserTab++);
        panel.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteBannerTab);
    }

    private function addBannerTab(label:String):BannersPanel {
        var panel:BannersPanel = new BannersPanelUI();
        panel.label = label;
        panel.name = label;
        bannersTabNavigator.addChild(panel);
        panel.addBannerB.addEventListener(MouseEvent.CLICK, onBannerAdd);
        if (bannersTabNavigator.numChildren > 1) {
            bannersTabNavigator.closePolicy = SuperTab.CLOSE_ALWAYS;
        } else if (bannersTabNavigator.numChildren <= 1) {
            bannersTabNavigator.closePolicy = SuperTab.CLOSE_NEVER;
        }
        return panel;
    }

    private function onCreationCompleteBannerTab(event:Event):void {
        var label:String = event.currentTarget.name;
        var superTab:SuperTab = openBannerTab(label);
        superTab.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
    }

    private function onCreationCompleteFirstBannerTab(event:Event):void {
        openBannerTab(event.currentTarget.name);
    }

    private function openBannerTab(label:String):SuperTab {
        var tab:DisplayObject = bannersTabNavigator.getChildByName(label);
        var indexTab:int = bannersTabNavigator.getChildIndex(tab);
        var superTab:SuperTab = bannersTabNavigator.getSuperTab(indexTab);
        superTab.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        return superTab;
    }

    private function onAdPlacesTabAdd(event:MouseEvent):void {
        var panel:AdPlacesPanel = addAdPlacesTab(DragNDropWizard.nameSiteTab + DragNDropWizard.counterSiteTab++);
        panel.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteAdPlaceTab);
    }

    private function addAdPlacesTab(label:String):AdPlacesPanel {
        var panel:AdPlacesPanel = new AdPlacesPanelUI();
        panel.label = label;
        panel.name = label;
        adPlacesTabNavigator.addChild(panel);
        panel.addAdPlaceB.addEventListener(MouseEvent.CLICK, onAdPlaceAdd);
        if (adPlacesTabNavigator.numChildren > 1) {
            adPlacesTabNavigator.closePolicy = SuperTab.CLOSE_ALWAYS;
        } else if (adPlacesTabNavigator.numChildren <= 1) {
            adPlacesTabNavigator.closePolicy = SuperTab.CLOSE_NEVER;
        }
        return panel;
    }

    private function onCreationCompleteAdPlaceTab(event:Event):void {
        var label:String = event.currentTarget.name;
        var superTab:SuperTab = openAdPlacesTab(label);
        superTab.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
    }

    private function onCreationCompleteFirstAdPlaceTab(event:Event):void {
        openAdPlacesTab(event.currentTarget.name);
    }

    private function openAdPlacesTab(label:String):SuperTab {
        var tab:DisplayObject = adPlacesTabNavigator.getChildByName(label);
        var indexTab:int = adPlacesTabNavigator.getChildIndex(tab);
        var superTab:SuperTab = adPlacesTabNavigator.getSuperTab(indexTab);
        superTab.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        return superTab;
    }

    public function setMaps(bbs:IMap, aps:IMap):void {
        banners = bbs;
        adPlaces = aps;

        var child:DisplayObject;
        for each (child in bannersTabNavigator.getChildren()) {
            if (child is BannersPanelUI) {
                (child as BannersPanelUI).removeAllBanners()
            }
        }
        for each (child in adPlacesTabNavigator.getChildren()) {
            if (child is AdPlacesPanelUI) {
                (child as AdPlacesPanelUI).removeAllAdPlaces()
            }
        }
        bannersTabNavigator.removeAllChildren();
        adPlacesTabNavigator.removeAllChildren();
        var bannersPanelLabel:ArrayCollection = getPanelLabels(bbs);
        var adPlacesPanelLabel:ArrayCollection = getPanelLabels(aps);

        var label:String;
        if (adPlacesPanelLabel.length == 0) {
            adPlacesPanelLabel.addItem(DragNDropWizard.nameSiteTab + DragNDropWizard.counterSiteTab++);
        }
        for each (label in adPlacesPanelLabel) {
            addAdPlacesTab(label);
        }
        if (bannersPanelLabel.length == 0) {
            bannersPanelLabel.addItem(DragNDropWizard.nameAdvertiserTab + DragNDropWizard.counterAdvertiserTab++);
        }
        for each (label in bannersPanelLabel) {
            addBannerTab(label);
        }
        var firstBannerTab:DisplayObject = bannersTabNavigator.getChildByName(bannersPanelLabel[0]);
        firstBannerTab.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteFirstBannerTab);
        var firstAdPlacesTab:DisplayObject = adPlacesTabNavigator.getChildByName(adPlacesPanelLabel[0]);
        firstAdPlacesTab.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationCompleteFirstAdPlaceTab);

        var k:int;
        var adPlace:AdPlaceVO;

        var dataSortField1:SortField = new SortField();
        //name of the field of the object on which you wish to sort the Collection
        dataSortField1.name = "displayOrder";
        dataSortField1.numeric = true;
        dataSortField1.descending = false;
        //create the sort object
        var dataSort:Sort = new Sort();
        dataSort.fields = [dataSortField1];

        //adPlaces
        var adPlaceAC:ArrayCollection = new ArrayCollection();
        for (i = 0; i < adPlaces.getKeys().length; i++) {
            adPlace = adPlaces.getValues()[i] as AdPlaceVO;
            adPlaceAC.addItem(adPlace);
        }
        adPlaceAC.sort = dataSort;
        adPlaceAC.refresh();
        for each(var adPlaceToAdd:AdPlaceVO in adPlaceAC) {
            addAdPlace(adPlaceToAdd, false);
        }
        //banners
        var bannerAC:ArrayCollection = new ArrayCollection();      //Map to arrayCollection (banner without adPlace)
        for (var i:int = 0; i < banners.getKeys().length; i++) {
            banner = banners.getValues()[i] as BannerVO;
            if (banner.adPlaceUid == null) {
                bannerAC.addItem(banner);
            }
        }
        bannerAC.sort = dataSort;
        bannerAC.refresh();
        for each(var banner:BannerVO in bannerAC) {
            addBanner(banner);
        }
        //AdPlace set adFormat enable
        for (k = 0; k < adPlaces.getKeys().length; k++) {
            adPlace = adPlaces.getValues()[k] as AdPlaceVO;
        }
    }

    public function onBannerPreView(banner:BannerVO):void {
        dispatchEvent(new ObjectEvent(PREVIEW_BANNER_BTN_CLICK, banner));
    }

    private function onBannerAdd(e:MouseEvent):void {
        dispatchEvent(new ObjectEvent(ADD_BANNER_BTN_CLICK, null));
    }


    public function onBannerRemove(uid:String):void {
        dispatchEvent(new ObjectEvent(REMOVE_BANNER_BTN_CLICK, uid));
    }

    public function onBannerEdit(uid:String):void {
        dispatchEvent(new ObjectEvent(EDIT_BANNER_BTN_CLICK, uid));
    }

    private function onAdPlaceAdd(e:MouseEvent):void {
        var adPlacesPanel:AdPlacesPanelUI = e.currentTarget.parent.parent.parent as AdPlacesPanelUI;
        var adPlace:AdPlaceVO = new AdPlaceVO();
        adPlace.adPlaceName = "new ad place " + AdPlaceVO.counter;
        adPlace.uid = ApplicationConstants.getNewUid();
        adPlace.label = adPlacesPanel.name;
        adPlaces.put(adPlace.uid, adPlace);
        addAdPlace(adPlace, true);
        dispatchEvent(new ObjectEvent(ADD_AD_PLACE_BTN_CLICK, adPlace.uid));
    }

    private function addAdPlace(adPlace:AdPlaceVO, setFocusOnCreate:Boolean):void {
        var newAdPlace:AdPlaceView = new AdPlaceViewUI();
        newAdPlace.dndWizard = this;
        newAdPlace.adPlaceUid = adPlace.uid;
        newAdPlace.setFocusOnCreate = setFocusOnCreate;
        var adPlacesPanel:AdPlacesPanelUI = getAdPlacesPanelByLabel(adPlace.label);
        adPlacesPanel.leftVB.addChildAt(newAdPlace, adPlacesPanel.leftVB.getChildren().length - 1);
        newAdPlace.updateAdPlaceDisplayOrder();
    }


    public function addBanner(banner:BannerVO):void {
        var newBanner:BannerView = new BannerViewUI();
        newBanner.dndWizard = this;
        newBanner.bannerUid = banner.uid;
        var bannersPanel:BannersPanelUI = getBannersPanelByLabel(banner.label);
        newBanner.id = "bannerView" + String(bannersPanel.rightVB.getChildren().length - 1);
        bannersPanel.rightVB.addChildAt(newBanner, bannersPanel.rightVB.getChildren().length - 1);
    }

    public function updateBanner(banner:BannerVO):void {
        var bannerView:BannerView = findBannerView(banner);
        bannerView.updateProviders();
    }

    public function addCustomEventListener(type:String, func:Function):void {
        this.addEventListener(type, func);
    }

    public function deleteAdPlace(ap:AdPlaceVO):void {
        var adPlacesPanel:AdPlacesPanelUI = getAdPlacesPanelByLabel(ap.label);
        var adPlaceView:AdPlaceView = adPlacesPanel.getAdPlaceViewByUid(ap.uid);
        if (adPlaceView != null)adPlacesPanel.leftVB.removeChild(adPlaceView);
    }

    public function bannerNameUpdate(banner:BannerVO):void {
        var bannerProxy:BannerProxy = ApplicationFacade.getInstance().retrieveProxy(BannerProxy.NAME) as BannerProxy;
        var relatedBanners:ArrayCollection = bannerProxy.getBannersByParentUid(banner.uid);
        for each (var iBanner:BannerVO in relatedBanners) {
            iBanner.bannerName = banner.bannerName;
        }
    }

    public function deleteBanner(banner:BannerVO):void {
        var bannerView:BannerView = findBannerView(banner);

        if (banner.adPlaceUid == null) {
            var bannersPanel:BannersPanelUI = getBannersPanelByLabel(banner.label);
            bannersPanel.rightVB.removeChild(bannerView);
        } else {
            if (bannerView != null) {
                var pad:Paddock = Paddock(bannerView.parent.parent);
                pad.contentVB.removeChild(bannerView);
                pad.refresh();
                pad.changeWatcher = !pad.changeWatcher;                
            }

            //need to enable ad format in parent banner if this is last assigned banner
            var parentBanner:BannerVO = banners.getValue(banner.parentUid) as BannerVO;
            if (parentBanner == null)return;//removing parent banner first, then child banners
            var parentBannerView:BannerView = findBannerView(parentBanner);
            parentBannerView.adFormatCB.enabled = parentBanner.isAdFormatEnabled();

        }
    }

    private function findBannerView(banner:BannerVO):BannerView {
        var bannersPanel:BannersPanelUI = getBannersPanelByLabel(banner.label);
        var bannerView:BannerView = bannersPanel.getBannerViewByUid(banner.uid);
        if (bannerView != null) {
            return bannerView;
        } else {
            var adPlace:AdPlaceVO = adPlaces.getValue(banner.adPlaceUid);
            var adPlacesPanel:AdPlacesPanelUI = getAdPlacesPanelByLabel(adPlace.label);
            bannerView = adPlacesPanel.getBannerViewByUid(banner.uid);
            if (bannerView != null) {
                return bannerView;
            } else {
                trace("Couldn't remove banner from ui:" + banner.uid);
            }
        }
        return null;
    }


    public function updateBannerInSession(event:Event):void {
        var uploadProxy:UploadProxy = ApplicationFacade.getInstance().retrieveProxy(UploadProxy.NAME) as UploadProxy;
        uploadProxy.uploadBannerToSession(event);
    }

    public function isOriginalAlreadyExists(bannerName:String, exceptUid:String):Boolean {
        for (var i:int = 0; i < banners.getKeys().length; i++) {
            var banner:BannerVO = banners.getValues()[i] as BannerVO;
            if (banner.adPlaceUid == null && banner.bannerName == bannerName && banner.uid != exceptUid) {
                return true;
            }
        }
        return false;
    }

    private function getPanel(titleName:String):Panel {
        var panel:Panel = new Panel();
        panel.title = titleName;
        panel.percentWidth = 50;
        panel.percentHeight = 100;
        panel.setStyle("borderThicknessTop", 0);
        panel.setStyle("borderThicknessRight", 0);
        panel.setStyle("borderThicknessLeft", 0);
        panel.setStyle("borderThicknessBottom", 0);
        panel.setStyle("borderColor", 0x000000);
        panel.setStyle("headerColors", [0x000000, 0x000000]);
        panel.setStyle("verticalAlign", "top");
        panel.setStyle("verticalGap", 0);
        panel.setStyle("dropShadowEnabled", false);
        //        panel.setStyle("color", 0xFFFFFF);
        return panel;
    }

    private function getTabNavigator():SuperTabNavigator {
        var tabNavigator:SuperTabNavigator = new SuperTabNavigator();
        tabNavigator.percentWidth = 100;
        tabNavigator.percentHeight = 100;
        tabNavigator.setStyle("paddingTop", 0);
        tabNavigator.setStyle("highlightAlphas", [0.52, 0.4]);
        tabNavigator.setStyle("fillAlphas", [1, 1]);
        tabNavigator.setStyle("fillColors", [0xECEADB, 0xECEADB]);
        tabNavigator.setStyle("backgroundColor", 0xFFFFFF);
        tabNavigator.setStyle("borderColor", 0x999999);
        tabNavigator.setStyle("color", 0x000000);
        tabNavigator.setStyle("textRollOverColor", 0x000000);
        tabNavigator.setStyle("textAlign", "left");
        tabNavigator.setStyle("tabWidth", 130);
        tabNavigator.editableTabLabels = true;
        tabNavigator.minTabWidth = 130;

        tabNavigator.scrollSpeed = 25;
        tabNavigator.setStyle("horizontalGap", 0);
        tabNavigator.dragEnabled = false;
        //        tabNavigator.setStyle("dropShadowEnabled", true);
        //        tabNavigator.stopScrollingEvent = MouseEvent.MOUSE_UP;
        //        tabNavigator.startScrollingEvent = MouseEvent.MOUSE_DOWN;

        tabNavigator.closePolicy = SuperTab.CLOSE_ALWAYS;
        tabNavigator.addEventListener(SuperTabEvent.TAB_CLOSE, onTabClose);
        tabNavigator.addEventListener(SuperTabEvent.TAB_UPDATED, onTabUpdated);
        return tabNavigator;
    }

    private function onTabClose(event:SuperTabEvent):void {
        event.preventDefault();
        selectedSuperTabNavigator = event.currentTarget as SuperTabNavigator;
        selectedTabIndex = event.tabIndex;
        var panel:Panel = selectedSuperTabNavigator.getChildAt(selectedTabIndex) as Panel;
        //        var numChildren:int = panel is AdPlacesPanelUI ? (panel as AdPlacesPanelUI).leftVB.numChildren : (panel as BannersPanelUI).rightVB.numChildren;
        var numChildren:int = selectedSuperTabNavigator.getChildren().length;
        if (numChildren > 1) {
            Alert.show("Do you want to delete this tab?", "Please Confirm", Alert.YES | Alert.NO, ApplicationConstants.application as Sprite, onClose);
        } else {
            Alert.show("Sorry, you can't remove the last tab.", "Alert", Alert.OK, ApplicationConstants.application as Sprite);
        }
    }

    private function onClose(event:CloseEvent):void {
        if (event.detail == Alert.YES) {
            var panel:Panel = selectedSuperTabNavigator.getChildAt(selectedTabIndex) as Panel;
            if (panel is AdPlacesPanelUI) {
                dispatchEvent(new ObjectEvent(REMOVE_AD_PLACE_TAB, panel.label));
            }
            if (panel is BannersPanelUI) {
                dispatchEvent(new ObjectEvent(REMOVE_BANNER_TAB, panel.label));
            }

            selectedSuperTabNavigator.removeChildAt(selectedTabIndex);
            if (selectedSuperTabNavigator.numChildren == 1) {
                selectedSuperTabNavigator.closePolicy = SuperTab.CLOSE_NEVER;
            }
        }
    }

    private function getBannersPanelByLabel(label:String):BannersPanelUI {
        return bannersTabNavigator.getChildByName(label) as BannersPanelUI;
    }

    private function getAdPlacesPanelByLabel(label:String):AdPlacesPanelUI {
        return adPlacesTabNavigator.getChildByName(label) as AdPlacesPanelUI;
    }

    private function getPanelLabels(map:IMap):ArrayCollection {
        var labels:ArrayCollection = new ArrayCollection();
        for each (var banner:Object in map.getValues()) {
            if (!labels.contains(banner.label)) {
                labels.addItem(banner.label);
            }
        }
        labels.sort = new Sort();
        labels.refresh();
        return labels;
    }

    private function onTabUpdated(event:SuperTabEvent):void {
        var superTabNavigator:Container = event.currentTarget as Container;
        var tabIndex:int = event.tabIndex;
        var panel:Panel = superTabNavigator.getChildAt(tabIndex) as Panel;
        if (panel is AdPlacesPanelUI) {
            var adPlacesPanel:AdPlacesPanelUI = panel as AdPlacesPanelUI;
            for (var i:int = 0; i < adPlacesPanel.leftVB.numChildren - 1; i++) {
                var adPlaceView:AdPlaceViewUI = adPlacesPanel.leftVB.getChildAt(i) as AdPlaceViewUI;
                var adPlace:AdPlaceVO = adPlaces.getValue(adPlaceView.adPlaceUid);
                adPlace.label = panel.label;
            }
            if (adPlacesPanel.leftVB.numChildren > 1) {
                dispatchEvent(new ObjectEvent(TAB_LABEL_CHANGE, panel.label));
            }
        }
        if (panel is BannersPanelUI) {
            var bannersPanel:BannersPanelUI = panel as BannersPanelUI;
            for (var j:int = 0; j < bannersPanel.rightVB.numChildren - 1; j++) {
                var bannerView:BannerViewUI = bannersPanel.rightVB.getChildAt(j) as BannerViewUI;
                var banner:BannerVO = banners.getValue(bannerView.bannerUid);
                banner.label = panel.label;
            }
            if (bannersPanel.rightVB.numChildren > 1) {
                dispatchEvent(new ObjectEvent(TAB_LABEL_CHANGE, panel.label));
            }
        }
    }
}
}