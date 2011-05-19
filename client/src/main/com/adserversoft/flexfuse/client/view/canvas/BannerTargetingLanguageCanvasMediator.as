package com.adserversoft.flexfuse.client.view.canvas {
import com.adserversoft.flexfuse.client.controller.BaseMediator;
import com.adserversoft.flexfuse.client.model.BannerProxy;
import com.adserversoft.flexfuse.client.model.SettingsProxy;
import com.adserversoft.flexfuse.client.model.vo.BaseVO;
import com.adserversoft.flexfuse.client.model.vo.LanguageVO;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.List;
import mx.core.UIComponent;
import mx.events.FlexEvent;

public class BannerTargetingLanguageCanvasMediator extends BaseMediator {
    public static const NAME:String = "BannerTargetingLanguageCanvasMediator";

    private var bannerProxy:BannerProxy;
    private var settingsProxy:SettingsProxy;

    public function BannerTargetingLanguageCanvasMediator(uid:String, viewComponent:Object) {
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
        var isAllLanguageSelected:Boolean = (uiComponent.banner.languageBits == null) ? true :
                uiComponent.banner.isAllBitsSelected(uiComponent.banner.languageBits);
        var allLanguages:ArrayCollection = new ArrayCollection();
        var someLanguages:ArrayCollection = new ArrayCollection();
        if (isAllLanguageSelected) {
            allLanguages = BaseVO.clone(settingsProxy.settings.languages);
        } else {
            for (var i:int = 0; i < BannerTargetingLanguageCanvas.nLanguages; i++) {
                if (uiComponent.banner.languageBits.charAt(i) == '1') {
                    someLanguages.addItem(settingsProxy.settings.languages.getItemAt(i));
                } else {
                    allLanguages.addItem(settingsProxy.settings.languages.getItemAt(i));
                }
            }
            sortLanguagesByName(someLanguages);
        }
        sortLanguagesByName(allLanguages);
        uiComponent.allLanguagesList.dataProvider = allLanguages;
        uiComponent.someLanguagesList.dataProvider = someLanguages;
        uiComponent.allLanguagesList.selectedIndex = 0;
        uiComponent.allLanguagesRB.selected = isAllLanguageSelected;
        uiComponent.languagesChangeHandler(null);

        addEventListeners();
    }

    public override function addEventListeners():void {
        uiComponent.addEventListener(BannerTargetingLanguageCanvas.ADD_ONE_LANGUAGE, addOneLanguage);
        uiComponent.addEventListener(BannerTargetingLanguageCanvas.ADD_ALL_LANGUAGES, addAllLanguages);
        uiComponent.addEventListener(BannerTargetingLanguageCanvas.REMOVE_ONE_LANGUAGE, removeOneLanguage);
        uiComponent.addEventListener(BannerTargetingLanguageCanvas.REMOVE_ALL_LANGUAGES, removeAllLanguages);
    }

    public override function removeEventListeners():void {
        uiComponent.removeEventListener(BannerTargetingLanguageCanvas.ADD_ONE_LANGUAGE, addOneLanguage);
        uiComponent.removeEventListener(BannerTargetingLanguageCanvas.ADD_ALL_LANGUAGES, addAllLanguages);
        uiComponent.removeEventListener(BannerTargetingLanguageCanvas.REMOVE_ONE_LANGUAGE, removeOneLanguage);
        uiComponent.removeEventListener(BannerTargetingLanguageCanvas.REMOVE_ALL_LANGUAGES, removeAllLanguages);
    }

    private function addOneLanguage(event:Event):void {
        transferLanguage(uiComponent.allLanguagesList, uiComponent.someLanguagesList);
    }

    private function addAllLanguages(event:Event):void {
        transferAllLanguage(uiComponent.allLanguagesList, uiComponent.someLanguagesList);
    }

    private function removeOneLanguage(event:Event):void {
        transferLanguage(uiComponent.someLanguagesList, uiComponent.allLanguagesList);
    }

    private function removeAllLanguages(event:Event):void {
        transferAllLanguage(uiComponent.someLanguagesList, uiComponent.allLanguagesList);
    }

    private function transferLanguage(fromList:List, toList:List):void {
        if (fromList.selectedItem != null) {
            enableButtons(false);
            var language:LanguageVO = fromList.selectedItem as LanguageVO;
            var fromDP:ArrayCollection = fromList.dataProvider as ArrayCollection;
            var toDP:ArrayCollection = toList.dataProvider as ArrayCollection;
            fromDP.removeItemAt(fromList.selectedIndex);
            toDP.addItem(language);
            sortLanguagesByName(fromDP);
            sortLanguagesByName(toDP);
            fromList.dataProvider = fromDP;
            toList.dataProvider = toDP;
            toList.selectedItem = language;
            toList.scrollToIndex(toList.selectedIndex);
            enableButtons(true);
        }
    }

    private function transferAllLanguage(fromList:List, toList:List):void {
        enableButtons(false);
        var toDP:ArrayCollection = BaseVO.clone(settingsProxy.settings.languages);
        sortLanguagesByName(toDP);
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

    private function sortLanguagesByName(arrayCollection:ArrayCollection):void {
        sortLanguagesByField(arrayCollection, "languageName");
    }

    private function sortLanguagesByField(arrayCollection:ArrayCollection, sortField:String):void {
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

    private function get uiComponent():BannerTargetingLanguageCanvas {
        return viewComponent as BannerTargetingLanguageCanvas;
    }
}
}