package com.adserversoft.flexfuse.client.model.vo {
public interface IDragNDropWizard {
    function setMaps(banners:IMap, adPlaces:IMap):void;

    function addCustomEventListener(type:String, func:Function):void;

    function addBanner(banner:BannerVO):void;

    function updateBanner(banner:BannerVO):void;

    function deleteAdPlace(ap:AdPlaceVO):void;

    function deleteBanner(banner:BannerVO):void;
}
}