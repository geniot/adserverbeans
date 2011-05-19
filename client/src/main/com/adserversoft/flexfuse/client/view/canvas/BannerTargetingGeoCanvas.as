package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.CountryVO;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.HBox;
import mx.controls.Button;
import mx.controls.List;
import mx.controls.RadioButton;
import mx.events.FlexEvent;

public class BannerTargetingGeoCanvas extends BaseCanvas {
    public static var ADD_ONE_COUNTRY:String = "ADD_ONE_COUNTRY";
    public static var ADD_ALL_COUNTRIES:String = "ADD_ALL_COUNTRIES";
    public static var REMOVE_ONE_COUNTRY:String = "REMOVE_ONE_COUNTRY";
    public static var REMOVE_ALL_COUNTRIES:String = "REMOVE_ALL_COUNTRIES";

    public var allCountriesRB:RadioButton;
    public var someCountryRB:RadioButton;
    public var countriesHB:HBox;

    public var addOneBtn:Button;
    public var addAllBtn:Button;
    public var refreshBtn:Button;
    public var removeOneBtn:Button;
    public var removeAllButton:Button;

    public var allCountriesList:List;
    public var someCountriesList:List;

    public var banner:BannerVO;

    public function BannerTargetingGeoCanvas() {
        super();
        addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
    }

    protected function onCreationComplete(event:Event):void {
        allCountriesRB.addEventListener(MouseEvent.CLICK, countriesChangeHandler);
        someCountryRB.addEventListener(MouseEvent.CLICK, countriesChangeHandler);

        addOneBtn.addEventListener(MouseEvent.CLICK, onAddOneClick);
        addAllBtn.addEventListener(MouseEvent.CLICK, onAddAllClick);
        removeOneBtn.addEventListener(MouseEvent.CLICK, onRemoveOneClick);
        removeAllButton.addEventListener(MouseEvent.CLICK, onRemoveAllClick);

        allCountriesList.addEventListener(MouseEvent.CLICK, onAllCountriesClick);
        someCountriesList.addEventListener(MouseEvent.CLICK, onSomeCountriesClick);
    }

    public function countriesChangeHandler(event:Event):void {
        var isAllCountriesSelected:Boolean = allCountriesRB.selected;
        someCountryRB.selected = !isAllCountriesSelected;
        countriesHB.enabled = !isAllCountriesSelected;
    }

    private function onAddOneClick(event:Event):void {
        dispatchEvent(new Event(ADD_ONE_COUNTRY));
    }

    private function onAddAllClick(event:Event):void {
        dispatchEvent(new Event(ADD_ALL_COUNTRIES));
    }

    private function onRemoveOneClick(event:Event):void {
        dispatchEvent(new Event(REMOVE_ONE_COUNTRY));
    }

    private function onRemoveAllClick(event:Event):void {
        dispatchEvent(new Event(REMOVE_ALL_COUNTRIES));
    }

    public function onAllCountriesClick(event:MouseEvent):void {
        someCountriesList.selectedItem = null;
    }

    public function onSomeCountriesClick(event:MouseEvent):void {
        allCountriesList.selectedItem = null;
    }

    public function getGeoBitsSelected():String {
        var countryBits:String = "";
        if (allCountriesRB.selected) {
            countryBits = ApplicationConstants.initBits(239, true); // = "11...11";
        } else {
            countryBits = ApplicationConstants.initBits(239, false); // = "00...00";
            var index:int;
            for each (var iCountry:CountryVO in someCountriesList.dataProvider) {
                index = int(iCountry.id) - 1;
                countryBits = countryBits.substring(0, index) + "1" + countryBits.substring(index + 1);
            }
        }
        return countryBits;
    }

    public function isSomeCountrySelected():Boolean {
        if (allCountriesRB.selected) {
            return true;
        }
        return someCountriesList.dataProvider.length!=0;
    }
}
}