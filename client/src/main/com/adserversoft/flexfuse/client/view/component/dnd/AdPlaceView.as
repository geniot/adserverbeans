package com.adserversoft.flexfuse.client.view.component.dnd {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;
import com.adserversoft.flexfuse.client.model.vo.ObjectEvent;
import com.adserversoft.flexfuse.client.view.component.button.ExpandToggleButton;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.binding.utils.BindingUtils;
import mx.binding.utils.ChangeWatcher;
import mx.containers.Box;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.Label;
import mx.controls.LinkButton;
import mx.controls.TextInput;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.CloseEvent;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.managers.DragManager;
import mx.managers.IFocusManagerComponent;

public class AdPlaceView extends DraggableControl {
    public var paddock:Paddock;
    public static const EXPAND_AD_PLACE:String = "EXPAND_AD_PLACE";
    public static const GET_AD_TAG:String = "GET_AD_TAG";
    public static const DELETE_AD_PLACE:String = "DELETE_AD_PLACE";

    public var expandB:ExpandToggleButton;
    public var adPlaceNameTI:TextInput;
    public var adFormatCB:ComboBox;
    public var viewsL:Label;
    public var clicksL:Label;
    public var ctrL:Label;
    public var dragB:Button;
    public var deleteBtn:LinkButton;
    public var getAdTagBtn:LinkButton;

    public var adPlaceUid:String;

    public var dndWizard:DragNDropWizard;
    public var invalidField:UIComponent;

    private var onFocusInAdPlaceName:String;
    public var setFocusOnCreate:Boolean = true;

    use namespace mx_internal;

    public function AdPlaceView() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    private function onCreationComplete(event:Event):void {
        paddock = new PaddockUI();
        paddock.dndWizard = dndWizard;

        var adPlace:AdPlaceVO = dndWizard.adPlaces.getValue(adPlaceUid);

        adFormatCB.dataProvider = ApplicationConstants.sortedAdFormatsCollection;
        adFormatCB.selectedItem = adPlace.adFormat;

        BindingUtils.bindProperty(adPlaceNameTI, "text", adPlace, "adPlaceName");
        BindingUtils.bindProperty(adPlace, "adPlaceName", adPlaceNameTI, "text");

        BindingUtils.bindProperty(viewsL, "text", adPlace, "views");
        BindingUtils.bindProperty(clicksL, "text", adPlace, "clicks");
        BindingUtils.bindProperty(ctrL, "text", adPlace, "ctr");

        BindingUtils.bindProperty(adFormatCB, "selectedItem", adPlace, "adFormat");
        BindingUtils.bindProperty(adPlace, "adFormat", adFormatCB, "selectedItem");


        //        BindingUtils.bindProperty(adFormatCB, "enabled", dndWizard.adPlaces.getValue(adPlaceUid), "isAdPlaceAdFormatEnabled");
        adFormatCB.enabled = !adPlace.hasBanners();

        adFormatCB.addEventListener(Event.CHANGE, onSelectionChanged);

        adPlaceNameTI.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        adPlaceNameTI.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
        adPlaceNameTI.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
        adPlaceNameTI.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, onFocusChange);
        adPlaceNameTI.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusChange);
        adPlaceNameTI.addEventListener(FlexEvent.ENTER, onFocusChange);

        dragB.addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
        expandB.addEventListener(MouseEvent.CLICK, doExpand);
        deleteBtn.addEventListener(MouseEvent.CLICK, onRemoveAdPlace);
        getAdTagBtn.addEventListener(MouseEvent.CLICK, onGetAdTag);

        //to pre-initialize paddock, see removal in Paddock.onCreationComplete
        addChild(paddock);

        ChangeWatcher.watch(paddock, "changeWatcher", onPaddockContentsChange);

        if (setFocusOnCreate)adPlaceNameTI.setFocus();
    }

    private function onPaddockContentsChange(e:*):void {
        var adPlace:AdPlaceVO = dndWizard.adPlaces.getValue(adPlaceUid);
        adFormatCB.enabled = !adPlace.hasBanners();
    }

    public function onRemoveAdPlace(e:MouseEvent):void {
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.REMOVE_AD_PLACE_BTN_CLICK, adPlaceUid));
    }

    public function onGetAdTag(e:MouseEvent):void {
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.GET_AD_TAG_AD_PLACE_BTN_CLICK, adPlaceUid));
    }

    private function onKeyUp(event:KeyboardEvent):void {
        if (event.keyCode == Keyboard.ESCAPE) {
            adPlaceNameTI.text = onFocusInAdPlaceName;
            changeFocus(event);
        }
    }

    public function onFocusIn(event:FocusEvent):void {
        onFocusInAdPlaceName = adPlaceNameTI.text;
        adPlaceNameTI.selectionEndIndex = adPlaceNameTI.text.length;
        UITextField(adPlaceNameTI.getTextField()).alwaysShowSelection = true;

    }

    private function onFocusOut(event:FocusEvent):void {
        adPlaceNameTI.setSelection(0, 0);
    }

    private function onFocusChange(event:Event):void {
        if (event is FocusEvent && FocusEvent(event).relatedObject is LinkButton) {
            var linkButton:LinkButton = FocusEvent(event).relatedObject as LinkButton;
            if (linkButton.id == "deleteBtn" && linkButton.document.adPlaceUid == adPlaceUid) {
                adPlaceNameTI.text = dndWizard.adPlaces.getValue(adPlaceUid).adPlaceName;
                changeFocus(event);
            }
        }
        if (ApplicationConstants.deleteWhiteSpaces(adPlaceNameTI.text) == "") {
            invalidField = adPlaceNameTI;
            Alert.show("Ad place name is required.", "Invalid", Alert.OK, ApplicationConstants.application as Sprite, onAlertClose);
        } else {
            if (onFocusInAdPlaceName != adPlaceNameTI.text) {
                dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.AD_PLACE_CHANGE, dndWizard.adPlaces.getValue(adPlaceUid)));
            }
            changeFocus(event);
        }
    }

    public function onAlertClose(event:CloseEvent):void {
        if (invalidField != null) invalidField.setFocus();
    }

    private function changeFocus(event:Event):void {
        adPlaceNameTI.selectionEndIndex = 0;
        UITextField(adPlaceNameTI.getTextField()).alwaysShowSelection = true;
        var component:InteractiveObject = event is FocusEvent ?
                FocusEvent(event).relatedObject : event.currentTarget.parent;
        if (component is IFocusManagerComponent) {
            IFocusManagerComponent(component).setFocus();
        } else {
            stage.focus = component;
        }
    }


    private function onSelectionChanged(event:Event):void {
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.AD_PLACE_CHANGE, dndWizard.adPlaces.getValue(adPlaceUid)));
    }

    protected override function doDragDrop(e:DragEvent):void {
        var draggedAdPlaceView:AdPlaceView = AdPlaceView(e.dragInitiator.parent);
        var dropTargetAdPlaceView:AdPlaceView = AdPlaceView(e.currentTarget);
        if (draggedAdPlaceView == dropTargetAdPlaceView) {
            draggedAdPlaceView.removeDropIndicators();
            dropTargetAdPlaceView.removeDropIndicators();
            return;
        }

        var ind:int = dropTargetAdPlaceView.parent.getChildIndex(dropTargetAdPlaceView);

        if (dropTargetAdPlaceView.indicatorPos == DraggableControl.INDICATOR_LOWER) {
            var childrenLength:int = Box(dropTargetAdPlaceView.parent).getChildren().length;
            ind = ind > childrenLength - 3 ? childrenLength - 3 : ind;
            dropTargetAdPlaceView.parent.addChildAt(draggedAdPlaceView, ind + 1);
        } else {
            ind = ind < 1 ? 0 : ind - 1;
            dropTargetAdPlaceView.parent.addChildAt(draggedAdPlaceView, ind);
        }

        draggedAdPlaceView.removeDropIndicators();
        dropTargetAdPlaceView.removeDropIndicators();
        dndWizard.dispatchEvent(new ObjectEvent(DragNDropWizard.AD_PLACE_CHANGE, dndWizard.adPlaces.getValue(adPlaceUid)));
        updateAdPlaceDisplayOrder();
    }

    private function onRemoveAdPlaceView(e:MouseEvent):void {
        var ab:AdPlaceView = AdPlaceView(e.currentTarget.parent.parent);
        ab.parent.removeChild(ab);
    }

    override protected function doDragEnter(e:DragEvent):void {
        var dropPlace:AdPlaceView = AdPlaceView(e.currentTarget);
        if (!(e.dragInitiator.parent is AdPlaceView))return;

        var isDropIndicatorAlreadyExists:Boolean = false;
        for (var i:int = 0; i < dropPlace.getChildren().length; i++) {
            var c:DisplayObject = dropPlace.getChildAt(i);
            if (c is DropIndicator) {
                isDropIndicatorAlreadyExists = true;
                break;
            }
        }
        if (!isDropIndicatorAlreadyExists) {
            if (dropPlace.contentMouseY > dropPlace.height / 2) {
                if (dropPlace.expandB.selected) {
                    dropPlace.addChildAt(new DropIndicator(), 2);
                } else {
                    dropPlace.addChildAt(new DropIndicator(), 1);
                }
            } else {
                dropPlace.addChildAt(new DropIndicator(), 0);
            }
        }
        DragManager.acceptDragDrop(dropPlace);
    }


    public function doExpand(e:MouseEvent):void {
        var ab:AdPlaceView = this;//AdPlaceView(e.currentTarget.parent.parent.parent);

        if (ab.expandB.selected) {
            ab.addChild(ab.paddock);
        } else {//removing paddock
            for (var i:int = 0; i < ab.getChildren().length; i++) {
                var c:DisplayObject = ab.getChildAt(i);
                if (c is Paddock) {
                    ab.removeChild(ab.paddock);
                    break;
                }
            }
        }

    }

    public function updateAdPlaceDisplayOrder():void {
        var i:int = 1;
        for each (var iDisplayObject:DisplayObject in (parent as VBox).getChildren()) {
            if (iDisplayObject is AdPlaceView) {
                var adPlace:AdPlaceVO = dndWizard.adPlaces.getValue((iDisplayObject as AdPlaceView).adPlaceUid);
                adPlace.displayOrder = i++;
            }
        }
    }


}
}