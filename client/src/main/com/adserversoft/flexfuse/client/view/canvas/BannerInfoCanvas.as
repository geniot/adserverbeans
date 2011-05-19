package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.vo.BannerFileVO;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.FormItem;
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.DataGrid;
import mx.controls.DateField;
import mx.controls.TextArea;
import mx.controls.TextInput;
import mx.events.FlexEvent;
import mx.validators.StringValidator;

public class BannerInfoCanvas extends BaseCanvas {
    public static const BROWSE:String = "BROWSE";
    [Bindable]
    public var bannerNameTI:TextInput;
    public var bannerFileFI:FormItem;
    public var frameTargetingFI:FormItem;
    [Bindable]
    public var targetURLTI:TextInput;
    public var targetURLFI:FormItem;
    [Bindable]
    public var bannerFileTI:TextInput;
    [Bindable]
    public var partyAdTagTA:TextArea;
    public var partyAdTagFI:FormItem;

    public var browseBtn:Button;
    public var adFormat:ComboBox;
    [Bindable]
    public var bannerFilesDP:ArrayCollection;
    public var bannerFilesDG:DataGrid;
    public var addFileB:Button;

    public var frameTargetingChB:ComboBox;

    public var bannerNameStringValidator:StringValidator;
    public var targetURLStringValidator:StringValidator;
    public var bannerFileStringValidator:StringValidator;

    public static const ONGOING_CHB_CLICK:String = "ONGOING_CHB_CLICK";
    public static const START_DATE_EDIT:String = "START_DATE_EDIT";
    public static const END_DATE_EDIT:String = "END_DATE_EDIT";
    public var startDateDF:DateField;
    public var endDateDF:DateField;
    public var ongoingChB:CheckBox;
    public var oneOnPageChB:CheckBox;
    public var partyAdTagChB:CheckBox;

    public var banner:BannerVO;

    public function BannerInfoCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event: Event):void {
        browseBtn.addEventListener(MouseEvent.CLICK, browse);
        bannerNameTI.addEventListener(FocusEvent.FOCUS_OUT, onDeleteWhiteSpace);
        ongoingChB.addEventListener(MouseEvent.CLICK, ongoingClick);
        startDateDF.addEventListener(Event.CHANGE, onStartDateEdit);
        endDateDF.addEventListener(Event.CHANGE, onEndDateEdit);
        partyAdTagChB.addEventListener(MouseEvent.CLICK, onPartyAdTagClick);
        addFileB.addEventListener(MouseEvent.CLICK, onAddFile);
        dispatchEvent(new Event(INIT));
    }

    private function onAddFile(e:Event):void {
        addNewFile();
        browse(e);
    }

    private function addNewFile():void {
        bannerFilesDP.addItem(new BannerFileVO());
        bannerFilesDG.rowCount = bannerFilesDP.length;
        bannerFilesDP.refresh();
    }

    public function onEditFile(event:MouseEvent):void {
        var selectedIndex:int = bannerFilesDG.selectedIndex;
        dispatchEvent(new Event(BROWSE));
    }

    private function browse(e:Event):void {
        dispatchEvent(new Event(BROWSE));
    }

    public function onDeleteFile(event:MouseEvent):void {
        bannerFilesDP.removeItemAt(bannerFilesDG.selectedIndex);
        if (bannerFilesDP.length == 0) {
            addNewFile();
        } else {
            bannerFilesDG.rowCount = bannerFilesDP.length;
            bannerFilesDP.refresh();
        }
    }

    public function validateURL():Boolean {
        var goodStartUrls:Array = new Array("http://www.", "http://", "www.");
        var url:String = new String(targetURLTI.text.toLowerCase());
        if (url == "http://www.") return false;
        var index:int;
        for (var i:int = 0; i < goodStartUrls.length; i++) {
            index = url.indexOf(goodStartUrls[i]);
            if (index == 0) {
                if (url.length > goodStartUrls[i].length) return true;
            }
        }
        return url.length > 0;
    }

    private function onDeleteWhiteSpace(focusEvent:FocusEvent):void {
        bannerNameTI.text = ApplicationConstants.deleteWhiteSpaces(bannerNameTI.text);
    }

    private function ongoingClick(event:Event):void {
        dispatchEvent(new Event(ONGOING_CHB_CLICK));
    }

//    public function validate_start_date():Boolean {
//        startDateDF.formatString = "MM/DD/YY";
//        var start:Date = startDateDF.selectedDate;
//        var thisMoment:Date = new Date();
//        var toDay:Date = new Date(thisMoment.getFullYear(), thisMoment.getMonth(), thisMoment.getDate(), 0, 0, 0, 0);
//        return start >= toDay;
//    }
//
//    public function validate_end_date():Boolean {
//        if (ongoingChB.selected) return true;
//        var start:Date = startDateDF.selectedDate;
//        var end:Date = endDateDF.selectedDate;
//        if (start > end) return false;
//        var thisMoment:Date = new Date();
//        var tomorrow:Date = new Date(thisMoment.getFullYear(), thisMoment.getMonth(), thisMoment.getDate() + 1, 0, 0, 0, 0);
//        return end >= tomorrow;
//    }

    private function onStartDateEdit(event:Event):void {
        dispatchEvent(new Event(START_DATE_EDIT));
    }

    private function onEndDateEdit(event:Event):void {
        dispatchEvent(new Event(END_DATE_EDIT));
    }

    public function onPartyAdTagClick(event:MouseEvent):void {
        var isPartyAdTag:Boolean = partyAdTagChB.selected;
        targetURLFI.enabled = !isPartyAdTag;
        bannerFileFI.enabled = !isPartyAdTag;
        frameTargetingFI.enabled = !isPartyAdTag;
        partyAdTagFI.enabled = isPartyAdTag;
        partyAdTagFI.visible = isPartyAdTag;
        partyAdTagFI.height = isPartyAdTag ? 165 : 0;
        targetURLFI.required = !isPartyAdTag;
        bannerFileFI.required = !isPartyAdTag;
        partyAdTagFI.required = isPartyAdTag;
    }

    public function isPartyAdTagEmpty():Boolean {
        return partyAdTagTA.length == 0;
    }
}
}