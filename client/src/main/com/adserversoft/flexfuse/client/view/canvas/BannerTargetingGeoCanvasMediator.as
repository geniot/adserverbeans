package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.BaseVO;
import com.adserversoft.flexfuse.client.model.vo.CountryVO;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.List;
import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingGeoCanvasMediator extends BaseMediator {
    public static const NAME:String = 'BannerTargetingGeoCanvasMediator';

    private var bannerProxy:BannerProxy;
    private var settingsProxy:SettingsProxy;

    public function BannerTargetingGeoCanvasMediator(uid:String, viewComponent:Object) {
        this.uid = uid;
        super(NAME, viewComponent);


        if (UIComponent(viewComponent).initialized) {
            onInit(null);
        } else {
            UIComponent(viewComponent).addEventListener(FlexEvent.CREATION_COMPLETE, onInit);
        }
    }

    private function onInit(event:Event):void {
        bannerProxy = facade.retrieveProxy(BannerProxy.NAME) as BannerProxy;
        settingsProxy = facade.retrieveProxy(SettingsProxy.NAME) as SettingsProxy;
        var isAllCountrySelected:Boolean = (uiComponent.banner.countryBits == null) ? true :
                uiComponent.banner.isAllBitsSelected(uiComponent.banner.countryBits);
        var allCountries:ArrayCollection = new ArrayCollection();
        var someCountries:ArrayCollection = new ArrayCollection();
        if (isAllCountrySelected) {
            allCountries = BaseVO.clone(settingsProxy.settings.countries);
        } else {
            for (var i:int = 0; i < 239; i++) {
                if (uiComponent.banner.countryBits.charAt(i) == '1') {
                    someCountries.addItem(settingsProxy.settings.countries.getItemAt(i));
                } else {
                    allCountries.addItem(settingsProxy.settings.countries.getItemAt(i));
                }
            }
            sortCountiesByName(someCountries);
        }
        sortCountiesByName(allCountries);
        uiComponent.allCountriesList.dataProvider = allCountries;
        uiComponent.someCountriesList.dataProvider = someCountries;
        uiComponent.allCountriesList.selectedIndex = 0;
        uiComponent.allCountriesRB.selected = isAllCountrySelected;
        uiComponent.countriesChangeHandler(null);

        addEventListeners();
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(BannerTargetingGeoCanvas.ADD_ONE_COUNTRY, addOneCountry);
        uiComponent.addEventListener(BannerTargetingGeoCanvas.ADD_ALL_COUNTRIES, addAllCountries);
        uiComponent.addEventListener(BannerTargetingGeoCanvas.REMOVE_ONE_COUNTRY, removeOneCountry);
        uiComponent.addEventListener(BannerTargetingGeoCanvas.REMOVE_ALL_COUNTRIES, removeAllCountries);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(BannerTargetingGeoCanvas.ADD_ONE_COUNTRY, addOneCountry);
        uiComponent.removeEventListener(BannerTargetingGeoCanvas.ADD_ALL_COUNTRIES, addAllCountries);
        uiComponent.removeEventListener(BannerTargetingGeoCanvas.REMOVE_ONE_COUNTRY, removeOneCountry);
        uiComponent.removeEventListener(BannerTargetingGeoCanvas.REMOVE_ALL_COUNTRIES, removeAllCountries);
    }

    private function addOneCountry(event:Event):void {
        transferCountry(uiComponent.allCountriesList, uiComponent.someCountriesList);
    }

    private function addAllCountries(event:Event):void {
        transferAllCountry(uiComponent.allCountriesList, uiComponent.someCountriesList);
    }

    private function removeOneCountry(event:Event):void {
        transferCountry(uiComponent.someCountriesList, uiComponent.allCountriesList);
    }

    private function removeAllCountries(event:Event):void {
        transferAllCountry(uiComponent.someCountriesList, uiComponent.allCountriesList);
    }

    private function transferCountry(fromList:List, toList:List):void {
        if (fromList.selectedItem != null) {
            enableButtons(false);
            var country:CountryVO = fromList.selectedItem as CountryVO;
            var fromDP:ArrayCollection = fromList.dataProvider as ArrayCollection;
            var toDP:ArrayCollection = toList.dataProvider as ArrayCollection;
            fromDP.removeItemAt(fromList.selectedIndex);
            toDP.addItem(country);
            sortCountiesByName(fromDP);
            sortCountiesByName(toDP);
            fromList.dataProvider = fromDP;
            toList.dataProvider = toDP;
            toList.selectedItem = country;
            toList.scrollToIndex(toList.selectedIndex);
            enableButtons(true);
        }
    }

    private function transferAllCountry(fromList:List, toList:List):void {
        enableButtons(false);
        var toDP:ArrayCollection = BaseVO.clone(settingsProxy.settings.countries);
        sortCountiesByName(toDP);
        toList.dataProvider = toDP;
        fromList.dataProvider = new ArrayCollection();
        enableButtons(true);
    }

    private function enableButtons(enabled:Boolean):void {
        uiComponent.addOneBtn.enabled = enabled;
        uiComponent.addAllBtn.enabled = enabled;
        uiComponent.removeOneBtn.enabled = enabled;
        uiComponent.removeAllButton.enabled = enabled;
    }

    private function sortCountiesByName(arrayCollection:ArrayCollection):void {
        sortCountiesByField(arrayCollection, "countryName");
    }

    private function sortCountiesByField(arrayCollection:ArrayCollection, sortField:String):void {
        if (arrayCollection != null) {
            var sort:Sort = new Sort();
            sort.fields = [new SortField(sortField)];
            arrayCollection.sort = sort;
            arrayCollection.refresh();
        }
    }

    public override function getMediatorName():String {
        return uid + "::" + NAME;
    }

    private function get uiComponent():BannerTargetingGeoCanvas {
        return viewComponent as BannerTargetingGeoCanvas;
    }
}
}