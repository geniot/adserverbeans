package com.adserversoft.flexfuse.client.model {
import com.adserversoft.flexfuse.client.model.vo.BannerVO;
import com.adserversoft.flexfuse.client.model.vo.DynamicParameterVO;
import com.adserversoft.flexfuse.client.model.vo.HashMap;
import com.adserversoft.flexfuse.client.model.vo.HashMapEntry;
import com.adserversoft.flexfuse.client.model.vo.IMap;
import com.adserversoft.flexfuse.client.model.vo.IpPatternVO;
import com.adserversoft.flexfuse.client.model.vo.ReferrerPatternVO;
import com.adserversoft.flexfuse.client.model.vo.UrlPatternVO;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.rpc.remoting.mxml.RemoteObject;

import org.puremvc.as3.interfaces.IProxy;
import org.puremvc.as3.patterns.proxy.Proxy;

public class BannerProxy extends Proxy implements IProxy {
    public static const NAME:String = 'BannerProxy';
    private var _banners:IMap = new HashMap();
    private var _urlPatterns:IMap = new HashMap();
    private var _referrerPatterns:IMap = new HashMap();
    private var _dynamicParameters:IMap = new HashMap();
    private var _ipPatterns:IMap = new HashMap();

    private var bannerRO:RemoteObject;

    public function BannerProxy() {
        super(NAME, new ArrayCollection);
        bannerRO = new RemoteObject();
        bannerRO.destination = "banner";
        bannerRO.requestTimeout = ApplicationConstants.REQUEST_TIMEOUT_SECONDS;
    }

    public function get banners():IMap {
        return _banners;
    }

    public function get urlPatterns():IMap {
        return _urlPatterns;
    }

    public function get referrerPatterns():IMap {
        return _referrerPatterns;
    }

    public function get dynamicParameters():IMap {
        return _dynamicParameters;
    }

    public function get ipPatterns():IMap {
        return _ipPatterns;
    }

    public function set banners(m:IMap):void {
        updateMap(m, _banners);
    }

    public function set urlPatterns(m:IMap):void {
        updateMap(m, _urlPatterns);
    }

    public function set referrerPatterns(m:IMap):void {
        updateMap(m, _referrerPatterns);
    }

    public function set dynamicParameters(m:IMap):void {
        updateMap(m, _dynamicParameters);
    }

    public function set ipPatterns(m:IMap):void {
        updateMap(m, _ipPatterns);
    }

    private function updateMap(newMap:IMap, existingMap:IMap):void {
        var entries:Array = newMap.getEntries();
        for (var i:int = 0; i < entries.length; i++) {
            var entry:HashMapEntry = entries[i];
            var key:String = entry.key;
            var obj:Object = entry.value;
            if (existingMap.containsKey(key)) {
                existingMap.getValue(key).mergeProperties(obj);
            } else {
                existingMap.put(key, obj);
            }
        }
    }

    public function getGroupCountByPriority(adPlaceUid:String, priority:int):int {
        var count:int = 0;
        for (var i:int = 0; i < _banners.getValues().length; i++) {
            var banner:BannerVO = _banners.getValues()[i];
            if (banner.adPlaceUid == adPlaceUid && banner.priority == priority)++count;
        }
        return count;
    }

    public function getTotalTrafficShare(adPlaceUid:String, priority:int):int {
        var totalTrafficShare:int = 0;
        for (var i:int = 0; i < _banners.getValues().length; i++) {
            var banner:BannerVO = _banners.getValues()[i];
            if (banner.adPlaceUid == adPlaceUid && banner.priority == priority) {
                totalTrafficShare += banner.trafficShare;
            }
        }
        return totalTrafficShare;
    }

    public function debugBanners():void {
        for (var i:int = 0; i < _banners.getValues().length; i++) {
            var banner:BannerVO = _banners.getValues()[i];
            trace(banner.toString());
        }
    }

    /**
     *
     * @param uid
     * @return collection of banners which parentUid equals uid
     */
    public function getBannersByParentUid(uid:String):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < _banners.getValues().length; i++) {
            var banner:BannerVO = _banners.getValues()[i];
            if (banner.parentUid == uid)ac.addItem(banner);
        }
        return ac;
    }

    /*    public function removeBannersByParentUid(uid:String):void {
     var bannersToDelete:ArrayCollection=getBannersByParentUid(uid);
     for (var i:int = 0; i < bannersToDelete.length; i++) {
     _banners.remove(bannersToDelete.getItemAt(i).uid);
     }
     }*/

    public function getBannersByAdPlaceUid(uid:String):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < _banners.getValues().length; i++) {
            var banner:BannerVO = _banners.getValues()[i];
            if (banner.adPlaceUid == uid)ac.addItem(banner);
        }
        var dataSortField:SortField = new SortField();
        dataSortField.name = "priority";
        dataSortField.numeric = true;
        var numericDataSort:Sort = new Sort();
        numericDataSort.fields = [dataSortField];
        ac.sort = numericDataSort;
        ac.refresh();
        return ac;
    }


    public function getPageUrlPatternsByBannerUid(uid:String):ArrayCollection {
        var pageUrlPatterns:ArrayCollection = new ArrayCollection();
        for each (var pageUrl:UrlPatternVO in _urlPatterns.getValues()) {
            if (pageUrl.bannerUid == uid) {
                pageUrlPatterns.addItem(pageUrl);
            }
        }
        return pageUrlPatterns;
    }

    public function getReferrerPatternsByBannerUid(uid:String):ArrayCollection {
        var referrerPatterns:ArrayCollection = new ArrayCollection();
        for each (var referrerPattern:ReferrerPatternVO in _referrerPatterns.getValues()) {
            if (referrerPattern.bannerUid == uid) {
                referrerPatterns.addItem(referrerPattern);
            }
        }
        return referrerPatterns;
    }


    public function getDynamicParametersBannerUid(uid:String):ArrayCollection {
        var dynamicParameters:ArrayCollection = new ArrayCollection();
        for each (var dynamicParameter:DynamicParameterVO in _dynamicParameters.getValues()) {
            if (dynamicParameter.bannerUid == uid) {
                dynamicParameters.addItem(dynamicParameter);
            }
        }
        return dynamicParameters;
    }

    public function getIpPatternsBannerUid(uid:String):ArrayCollection {
        var ipPatterns:ArrayCollection = new ArrayCollection();
        for each (var ipPattern:IpPatternVO in _ipPatterns.getValues()) {
            if (ipPattern.bannerUid == uid) {
                ipPatterns.addItem(ipPattern);
            }
        }
        return ipPatterns;
    }


    public function isOriginalAlreadyExists(bannerName:String, uid:String):Boolean {
        for (var i:int = 0; i < banners.getKeys().length; i++) {
            var banner:BannerVO = banners.getValues()[i] as BannerVO;
            if (banner.adPlaceUid == null && banner.bannerName == bannerName && banner.uid != uid) {
                return true;
            }
        }
        return false;
    }

    /**
     *
     * @param label
     * @return collection of banners which field label equals param label
     */
    public function getBannersByLabel(label:String):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for each (var banner:BannerVO in _banners.getValues()) {
            if (banner.label == label) {
                ac.addItem(banner);
            }
        }
        return ac;
    }


    public function removeUrlPatternsByBannerUid(uid:String):void {
        removeFromMapByBannerUid(_urlPatterns, uid);
    }

    public function removeReferrerPatternsByBannerUid(uid:String):void {
        removeFromMapByBannerUid(_referrerPatterns, uid);
    }

    public function removeDynamicParametersByBannerUid(uid:String):void {
        removeFromMapByBannerUid(_dynamicParameters, uid);
    }

    public function removeIpPatternsByBannerUid(uid:String):void {
        removeFromMapByBannerUid(_ipPatterns, uid);
    }

    private function removeFromMapByBannerUid(m:IMap, uid:String):void {
        for each (var pattern:Object in m.getValues()) {
            if (pattern.bannerUid == uid) {
                m.remove(pattern.id);
            }
        }
    }

    public function cloneUrlPatterns(uid:String, childUid:String):void {
        var parentsUrlPatterns:ArrayCollection = getPageUrlPatternsByBannerUid(uid);
        var urlPatternsIM:IMap = new HashMap();
        for each (var up:UrlPatternVO in parentsUrlPatterns) {
            var newUP:UrlPatternVO = up.clone();
            newUP.bannerUid = childUid;
            urlPatternsIM.put(ApplicationConstants.getNewUidForMap(urlPatternsIM), newUP);
        }
        this.urlPatterns = urlPatternsIM;
    }

    public function cloneDynamicParameter(uid:String, childUid:String):void {
        var parentsDynamicParameters:ArrayCollection = getDynamicParametersBannerUid(uid);
        var dynamicParameters:IMap = new HashMap();
        for each (var dp:DynamicParameterVO in parentsDynamicParameters) {
            var newDP:DynamicParameterVO = dp.clone();
            newDP.bannerUid = childUid;
            dynamicParameters.put(ApplicationConstants.getNewUidForMap(dynamicParameters), newDP);
        }
        this.dynamicParameters = dynamicParameters;
    }

    public function cloneReferrerPattern(uid:String, childUid:String):void {
        var parentsReferrerPatterns:ArrayCollection = getReferrerPatternsByBannerUid(uid);
        var referrerPatternsIM:IMap = new HashMap();
        for each (var rp:ReferrerPatternVO in parentsReferrerPatterns) {
            var newRP:ReferrerPatternVO = rp.clone();
            newRP.bannerUid = childUid;
            referrerPatternsIM.put(ApplicationConstants.getNewUidForMap(referrerPatternsIM), newRP);
        }
        this.referrerPatterns = referrerPatternsIM;
    }

    public function cloneIpPattern(uid:String, childUid:String):void {
        var parentsIpPatterns:ArrayCollection = getIpPatternsBannerUid(uid);
        var ipPatternsIM:IMap = new HashMap();
        for each (var ip:IpPatternVO in parentsIpPatterns) {
            var newIp:IpPatternVO = ip.clone();
            newIp.bannerUid = childUid;
            ipPatternsIM.put(ApplicationConstants.getNewUidForMap(ipPatternsIM), newIp);
        }
        this.ipPatterns = ipPatternsIM;
    }
}
}