package com.adserversoft.flexfuse.client.view.component.dnd {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.ObjectEvent;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
import flash.utils.ByteArray;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.HRule;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.controls.VRule;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.managers.DragManager;
import mx.managers.IFocusManagerComponent;

public class BannerView extends DraggableControl {
    public static const DRAG_BANNER:String = "DRAG_BANNER";
    public static const EDIT_BANNER:String = "EDIT_BANNER";
    public static const PREVIEW_BANNER:String = "PREVIEW_BANNER";

    [Bindable]
    public var changeWatcher:Boolean;

    public var hBox:HBox;
    public var dragB:Button;
    public var bannerNameTI:TextInput;
    public var adFormatCB:ComboBox;
    public var fileSizeL:Label;
    public var fileSizeVR:VRule;
    public var bannerNameVR:VRule;
    public var headersHB:HBox;
    public var hRule:HRule;
    public var trafficShareTI:TextInput;
    public var trafficShareVR:VRule;
    public var viewsL:Label;
    public var viewsVR:VRule;
    public var clicksL:Label;
    public var clicksVR:VRule;
    public var dragVR:VRule;
    public var ctrL:Label;
    public var ctrVR:VRule;
    public var topBorderLineHR:HRule;
    public var activateB:Button;
    public var activateVR:VRule;
    public var adFormatVR:VRule;
    public var containerVB:VBox;
    public var deleteBtn:Button;
    public var previewBtn:Button;
    public var editBtn:Button;

    public var onFocusInBannerName:String;

    public var invalidField:UIComponent;

    public var bannerUid:String;
    public var dndWizard:DragNDropWizard;

    public static var REGULAR_STATE:String = "REGULAR_STATE";
    public static var ASSIGNED_STATE:String = "ASSIGNED_STATE";

    public var currentStateName:String = REGULAR_STATE;


    use namespace mx_internal;

    public function BannerView() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        var banner:BannerVO = dndWizard.banners.getValue(bannerUid);

        adFormatCB.dataProvider = ApplicationConstants.sortedAdFormatsCollection;

        BindingUtils.bindProperty(bannerNameTI, "text", banner, "bannerName");
        BindingUtils.bindProperty(banner, "bannerName", bannerNameTI, "text");

        BindingUtils.bindProperty(trafficShareTI, "text", banner, "trafficShare");
        BindingUtils.bindProperty(banner, "trafficShare", trafficShareTI, "text");

        BindingUtils.bindProperty(fileSizeL, "text", banner, "fileSizeString");

        BindingUtils.bindProperty(adFormatCB, "selectedItem", banner, "adFormat");
        BindingUtils.bindProperty(banner, "adFormat", adFormatCB, "selectedItem");

        BindingUtils.bindProperty(viewsL, "text", banner, "views");
        BindingUtils.bindProperty(clicksL, "text", banner, "clicks");
        BindingUtils.bindProperty(ctrL, "text", banner, "ctr");

        ChangeWatcher.watch(this, "changeWatcher", onStateChanged);

        adFormatCB.enabled = BannerVO(dndWizard.banners.getValue(bannerUid)).isAdFormatEnabled();
        adFormatCB.selectedItem = banner.adFormat;

        bannerNameTI.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        bannerNameTI.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
        bannerNameTI.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onFocusChange);
        bannerNameTI.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusChange);
        bannerNameTI.addEventListener(FlexEvent.ENTER, onFocusChange);

        //if this is a newly created drag-n-dropped banner
        if (banner.parentUid != null) {
            bannerNameTI.focusEnabled = false;
            bannerNameTI.editable = false;
            bannerNameTI.selectable = false;
            var paddock:Paddock = this.parent.parent as Paddock;
            ChangeWatcher.watch(paddock, "changeWatcher", onStateChanged);
        }

        trafficShareTI.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        trafficShareTI.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onFocusChange);
        trafficShareTI.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusChange);
        trafficShareTI.addEventListener(FlexEvent.ENTER, onFocusChange);

        dragB.addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
        activateB.addEventListener(MouseEvent.CLICK, onChangeStateBanner);
        deleteBtn.addEventListener(MouseEvent.CLICK, onRemoveBanner);
        previewBtn.addEventListener(MouseEvent.CLICK, onPreviewBanner);
        editBtn.addEventListener(MouseEvent.CLICK, onEditBanner);

        adFormatCB.addEventListener(Event.CHANGE, onSelectionChanged);

        activateB.selected = (banner.bannerState == ApplicationConstants.STATE_ACTIVE) ? false : true;

        setState(currentStateName);
    }

    private function getDisplayOrder():int {
        var i:int = 1;
        if (parent == null)return i;
        for each (var iDisplayObject:DisplayObject in (parent as VBox).getChildren()) {
            if (iDisplayObject == this) {
                return i;
            } else if (iDisplayObject is BannerView) {
                ++i;
            }
        }
        return i;
    }

    private function onStateChanged(e:*):void {
        //banner removed? no need to do anything with the view
        if (!dndWizard.banners.containsKey(bannerUid))return;

        var bannerProxy:BannerProxy = ApplicationFacade.getInstance().retrieveProxy(BannerProxy.NAME) as BannerProxy;

        //updating ad format combo box enabled state if necessary
        adFormatCB.enabled = BannerVO(dndWizard.banners.getValue(bannerUid)).isAdFormatEnabled();
        var banner:BannerVO = BannerVO(dndWizard.banners.getValue(bannerUid));

        //updating display order
        banner.displayOrder = getDisplayOrder();

        var totalTrafficShare:int = bannerProxy.getTotalTrafficShare(banner.adPlaceUid, banner.priority);
        if (totalTrafficShare != 100) {  // wrong traffic share
            trafficShareTI.setStyle("color", "0xFF0000");
        } else {
            trafficShareTI.setStyle("color", "0x000000");
        }
    }


    public function updateProviders():void {
        var banner:BannerVO = dndWizard.banners.getValue(bannerUid);
        adFormatCB.selectedItem = banner.adFormat;
    }

    private function setState(c:String):void {
        if (c == REGULAR_STATE) {

        } else if (c == ASSIGNED_STATE) {
            headersHB.removeChild(fileSizeL);
            headersHB.removeChild(fileSizeVR);

            headersHB.addChildAt(activateB, headersHB.getChildIndex(dragVR));
            headersHB.addChildAt(activateVR, headersHB.getChildIndex(activateB));

            headersHB.addChildAt(trafficShareTI, headersHB.getChildIndex(bannerNameVR));
            headersHB.addChildAt(trafficShareVR, headersHB.getChildIndex(trafficShareTI));

            //            headersHB.addChildAt(viewsL, headersHB.getChildIndex(adFormatVR));
            //            headersHB.addChildAt(viewsVR, headersHB.getChildIndex(viewsL));
            //
            //            headersHB.addChildAt(clicksL, headersHB.getChildIndex(viewsVR));
            //            headersHB.addChildAt(clicksVR, headersHB.getChildIndex(clicksL));
            //
            //            headersHB.addChildAt(ctrL, headersHB.getChildIndex(clicksVR));
            //            headersHB.addChildAt(ctrVR, headersHB.getChildIndex(ctrL));
        }
    }

    /**
     * Adding/removing top border depending on the neighbor above
     */
    public function refresh():void {
        try {
            var parentContainer:VBox = VBox(this.parent);
            var ind:int = parentContainer.getChildIndex(this);
            if (parentContainer.getChildAt(ind - 1) is BannerView) {//removing top border
                topBorderLineHR.visible = false;
                topBorderLineHR.height = 0;
            } else {//adding top border
                topBorderLineHR.visible = true;
                topBorderLineHR.height = 1;
            }
        } catch(e:*) {
        }
    }

    private function onKeyUp(event:KeyboardEvent):void {
        if (event.keyCode == Keyboard.ESCAPE) {
            if (event.currentTarget == bannerNameTI) {
                bannerNameTI.text = onFocusInBannerName;
                changeFocus(event);
            } else {
                var trafficShareString:String = trafficShareTI.text;
                if (int(trafficShareTI.text) > 100) {
                    trafficShareTI.text = String(100);
                }
                if (int(trafficShareTI.text) < 1) {
                    trafficShareTI.text = String(1);
                }
                changeFocus(event);
            }
        }
    }

    private function onFocusIn(event:FocusEvent):void {
        var banner:BannerVO = dndWizard.banners.getValue(bannerUid);
        if (banner.parentUid != null) {
            stage.focus = null;
            return;
        }
        onFocusInBannerName = bannerNameTI.text;
        bannerNameTI.selectionEndIndex = bannerNameTI.text.length;
        UITextField(bannerNameTI.getTextField()).alwaysShowSelection = true;
    }

    private function onFocusChange(event:Event):void {
        if (event.currentTarget == bannerNameTI) {

            if (dndWizard.isOriginalAlreadyExists(bannerNameTI.text, bannerUid)) {
                invalidField = bannerNameTI;
                Alert.show("Banner with such name already exists.",
                        "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
                return;
            }

            if (ApplicationConstants.deleteWhiteSpaces(bannerNameTI.text) == "") {
                invalidField = bannerNameTI;
                Alert.show("Banner name is required.",
                        "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
            } else {
                dndWizard.banners.getValue(bannerUid).bannerName = bannerNameTI.text;
                dndWizard.bannerNameUpdate(dndWizard.banners.getValue(bannerUid));
            }
            changeFocus(event);
        } else if (event.currentTarget == trafficShareTI) {
            var trafficShareString:String = trafficShareTI.text;
            if (int(trafficShareTI.text) > 100) {
                trafficShareTI.text = String(100);
            }
            if (int(trafficShareTI.text) < 1) {
                trafficShareTI.text = String(1);
            }
            var paddock:Paddock = this.parent.parent as Paddock;
            paddock.changeWatcher = !paddock.changeWatcher;
            changeFocus(event);
        }
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.BANNER_CHANGE, dndWizard.banners.getValue(bannerUid)));

    }

    public function onAlertClose(event:CloseEvent):void {
        if (invalidField != null) invalidField.setFocus();
    }

    private function changeFocus(event:Event):void {
        bannerNameTI.selectionEndIndex = 0;
        UITextField(bannerNameTI.getTextField()).alwaysShowSelection = true;
        var component:InteractiveObject = event is FocusEvent ?
                                          FocusEvent(event).relatedObject : event.currentTarget.parent;
        if (component is IFocusManagerComponent) {
            IFocusManagerComponent(component).setFocus();
        } else {
            stage.focus = component;
        }
    }


    private function onSelectionChanged(event:Event):void {
        dndWizard.updateBannerInSession(event);
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.BANNER_CHANGE, dndWizard.banners.getValue(bannerUid)));
    }


    public function clone():* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(this);
        myBA.position = 0;
        return(myBA.readObject());
    }

    private function onRemoveBanner(e:MouseEvent):void {
        var ab:BannerView = BannerView(e.currentTarget.parent.parent.parent.parent);
        dndWizard.onBannerRemove(ab.bannerUid);
    }

    private function onChangeStateBanner(e:MouseEvent):void {
        var ab:BannerView = BannerView(e.currentTarget.parent.parent.parent);
        BannerVO(dndWizard.banners.getValue(ab.bannerUid)).bannerState = activateB.selected ? ApplicationConstants.STATE_INACTIVE : ApplicationConstants.STATE_ACTIVE;
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.BANNER_CHANGE, ab));
    }

    private function onEditBanner(e:MouseEvent):void {
        var ab:BannerView = BannerView(e.currentTarget.parent.parent.parent.parent);
        dndWizard.onBannerEdit(ab.bannerUid);
    }

    private function onPreviewBanner(e:MouseEvent):void {
        var ab:BannerView = BannerView(e.currentTarget.parent.parent.parent.parent);
        var banner:BannerVO = dndWizard.banners.getValue(ab.bannerUid);
        dndWizard.onBannerPreView(banner);

    }


    override protected function doDragEnter(e:DragEvent):void {
        var dropPlaceBannerView:BannerView = BannerView(e.currentTarget);
        var draggedBannerView:BannerView = BannerView(e.dragInitiator.parent);

        var dropBanner:BannerVO = dndWizard.banners.getValue(dropPlaceBannerView.bannerUid);
        var draggedBanner:BannerVO = dndWizard.banners.getValue(draggedBannerView.bannerUid);

        var isDragLeft:Boolean = draggedBannerView.parent.parent is Paddock;
        var isDropLeft:Boolean = dropPlaceBannerView.parent.parent is Paddock;

        //only with banners
        if (!(e.dragInitiator.parent is BannerView))return;


        //if dragging from left to right
        if (!(isDropLeft) && isDragLeft) {
            return;
        }

        //is drop to left                                    if drop to right
        if (dropBanner.adFormat == draggedBanner.adFormat || !(isDropLeft)) {

            var isDropIndicatorAlreadyExists:Boolean = false;
            for (var i:int = 0; i < dropPlaceBannerView.getChildren().length; i++) {
                var c:DisplayObject = dropPlaceBannerView.getChildAt(i);
                if (c is DropIndicator) {
                    isDropIndicatorAlreadyExists = true;
                    break;
                }
            }
            if (!isDropIndicatorAlreadyExists) {
                if (dropPlaceBannerView.contentMouseY > dropPlaceBannerView.height / 2) {
                    dropPlaceBannerView.addChildAt(new DropIndicator(), 2);
                } else {
                    dropPlaceBannerView.addChildAt(new DropIndicator(), 0);
                }
            }


            DragManager.acceptDragDrop(dropPlaceBannerView);
        }


    }

    override protected function doDragDrop(e:DragEvent):void {
        var draggedBannerView:BannerView = BannerView(e.dragInitiator.parent);
        var dropPlaceBannerView:BannerView = BannerView(e.currentTarget);
        var newBannerView:BannerView = draggedBannerView;
        var bannerProxy:BannerProxy = ApplicationFacade.getInstance().retrieveProxy(BannerProxy.NAME) as BannerProxy;

        //dragging from right panel to right panel
        if (!(dropPlaceBannerView.parent.parent is Paddock)) {
            super.doDragDrop(e);
            draggedBannerView.removeDropIndicators();
            dropPlaceBannerView.removeDropIndicators();
            draggedBannerView.changeWatcher = !draggedBannerView.changeWatcher;
            dropPlaceBannerView.changeWatcher = !dropPlaceBannerView.changeWatcher;
            dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.BANNER_CHANGE, draggedBannerView));
            return;
        }
        //else...
        var dropPaddock:Paddock = Paddock(dropPlaceBannerView.parent.parent);
        var dropAdPlaceView:AdPlaceView = AdPlaceView(dropPaddock.parent);

        //no changes necessary if dropping on yourself, just remove drop indicators
        if (draggedBannerView == dropPlaceBannerView) {
            draggedBannerView.removeDropIndicators();
            dropPlaceBannerView.removeDropIndicators();
            return;
        }

        var ind:int;
        var childrenLength:int;


        //dragging from paddock to paddock
        if (draggedBannerView.parent.parent is Paddock) {
            var dragPaddock:Paddock = Paddock(draggedBannerView.parent.parent);
            //calculating insertion index
            ind = dropPaddock.contentVB.getChildIndex(dropPlaceBannerView);
            if (dropPlaceBannerView.indicatorPos == DraggableControl.INDICATOR_UPPER) {
                ind = ind < 2 ? 1 : ind - 1;
            } else {
                childrenLength = dropPaddock.contentVB.getChildren().length;
                ind = ind > childrenLength - 3 ? childrenLength - 3 : ind;
                ++ind;
            }
            //inserting
            var dragBannerPriority:int = dndWizard.banners.getValue(draggedBannerView.bannerUid).priority;
            dropPaddock.contentVB.addChildAt(draggedBannerView, ind);

            //dragging from right panel to paddock
        } else {
            //creating a new banner
            newBannerView = new BannerViewUI();
            newBannerView.dndWizard = dndWizard;

            //creating new banner vo using clone
            var newBanner:BannerVO = BannerVO(dndWizard.banners.getValue(draggedBannerView.bannerUid)).clone();
            newBanner.views = 0;
            newBanner.clicks = 0;

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

            //find insertion point

            ind = dropPaddock.contentVB.getChildIndex(dropPlaceBannerView);
            if (dropPlaceBannerView.indicatorPos == DraggableControl.INDICATOR_UPPER) {
                ind = ind < 2 ? 1 : ind;
            } else {
                childrenLength = dropPaddock.contentVB.getChildren().length;
                childrenLength = dropPaddock.contentVB.getChildren().length;
                ind = ind > childrenLength - 2 ? childrenLength - 2 : ind;
                ++ind;
            }
            //inserting
            dropPaddock.contentVB.addChildAt(newBannerView, ind);
        }

        BannerVO(dndWizard.banners.getValue(newBannerView.bannerUid)).adPlaceUid = dropAdPlaceView.adPlaceUid;

        //we need to remove drop indicators in any case
        draggedBannerView.removeDropIndicators();
        dropPlaceBannerView.removeDropIndicators();

        dropPaddock.refresh();
        if (dragPaddock != null)dragPaddock.refresh();
        draggedBannerView.refresh();
        dropPlaceBannerView.refresh();
        newBannerView.refresh();

        dropPaddock.changeWatcher = !dropPaddock.changeWatcher;
        draggedBannerView.changeWatcher = !draggedBannerView.changeWatcher;
        newBannerView.changeWatcher = !draggedBannerView.changeWatcher;
        if (dragPaddock != null)dragPaddock.changeWatcher = !dragPaddock.changeWatcher;

        //notifying of the state change
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.BANNER_CHANGE, newBannerView));
    }


}
}