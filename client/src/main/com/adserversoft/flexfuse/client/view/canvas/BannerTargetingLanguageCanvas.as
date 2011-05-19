package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.LanguageVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.HBox;
import mx.controls.Button;
import mx.controls.List;
import mx.controls.RadioButton;
import mx.events.FlexEvent;

public class BannerTargetingLanguageCanvas extends BaseCanvas {
    public static const nLanguages:int = 122;

    public static var ADD_ONE_LANGUAGE:String = "ADD_ONE_LANGUAGE";
    public static var ADD_ALL_LANGUAGES:String = "ADD_ALL_LANGUAGES";
    public static var REMOVE_ONE_LANGUAGE:String = "REMOVE_ONE_LANGUAGE";
    public static var REMOVE_ALL_LANGUAGES:String = "REMOVE_ALL_LANGUAGES";

    public var allLanguagesRB:RadioButton;
    public var someLanguageRB:RadioButton;
    public var languagesHB:HBox;

    public var addOneBtn:Button;
    public var addAllBtn:Button;
    public var removeOneBtn:Button;
    public var removeAllButton:Button;

    public var allLanguagesList:List;
    public var someLanguagesList:List;

    public var banner:BannerVO;

    public function BannerTargetingLanguageCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        allLanguagesRB.addEventListener(MouseEvent.CLICK, languagesChangeHandler);
        someLanguageRB.addEventListener(MouseEvent.CLICK, languagesChangeHandler);

        addOneBtn.addEventListener(MouseEvent.CLICK, onAddOneClick);
        addAllBtn.addEventListener(MouseEvent.CLICK, onAddAllClick);
        removeOneBtn.addEventListener(MouseEvent.CLICK, onRemoveOneClick);
        removeAllButton.addEventListener(MouseEvent.CLICK, onRemoveAllClick);

        allLanguagesList.addEventListener(MouseEvent.CLICK, onAllLanguagesClick);
        someLanguagesList.addEventListener(MouseEvent.CLICK, onSomeLanguagesClick);
    }

    public function languagesChangeHandler(event:Event):void {
        var isAllLanguagesSelected:Boolean = allLanguagesRB.selected;
        someLanguageRB.selected = !isAllLanguagesSelected;
        languagesHB.enabled = !isAllLanguagesSelected;
    }

    private function onAddOneClick(event:Event):void {
        dispatchEvent(new Event(ADD_ONE_LANGUAGE));
    }

    private function onAddAllClick(event:Event):void {
        dispatchEvent(new Event(ADD_ALL_LANGUAGES));
    }

    private function onRemoveOneClick(event:Event):void {
        dispatchEvent(new Event(REMOVE_ONE_LANGUAGE));
    }

    private function onRemoveAllClick(event:Event):void {
        dispatchEvent(new Event(REMOVE_ALL_LANGUAGES));
    }

    public function onAllLanguagesClick(event:MouseEvent):void {
        someLanguagesList.selectedItem = null;
    }

    public function onSomeLanguagesClick(event:MouseEvent):void {
        allLanguagesList.selectedItem = null;
    }

    public function getLanguagesBitsSelected():String {
        var languageBits:String = "";
        if (allLanguagesRB.selected) {
            languageBits = ApplicationConstants.initBits(nLanguages, true); // = "11...11";
        } else {
            languageBits = ApplicationConstants.initBits(nLanguages, false); // = "00...00";
            var index:int;
            for each (var iLanguage:LanguageVO in someLanguagesList.dataProvider) {
                index = int(iLanguage.id) - 1;
                languageBits = languageBits.substring(0, index) + "1" + languageBits.substring(index + 1);
            }
        }
        return languageBits;
    }

    public function isSomeLanguageSelected():Boolean {
        if (allLanguagesRB.selected) {
            return true;
        }
        return someLanguagesList.dataProvider.length!=0;
    }
}
}