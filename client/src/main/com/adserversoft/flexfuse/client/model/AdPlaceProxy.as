package com.adserversoft.flexfuse.client.model {
import com.adserversoft.flexfuse.client.model.vo.AdPlaceVO;
import com.adserversoft.flexfuse.client.model.vo.HashMap;
import com.adserversoft.flexfuse.client.model.vo.HashMapEntry;
import com.adserversoft.flexfuse.client.model.vo.IMap;

import mx.collections.ArrayCollection;

import org.puremvc.as3.interfaces.IProxy;
import org.puremvc.as3.patterns.proxy.Proxy;

public class AdPlaceProxy extends Proxy implements IProxy {
    public static const NAME:String = 'AdPlaceProxy';

    private var _adPlaces:IMap = new HashMap();

    public function AdPlaceProxy() {
        super(NAME, new ArrayCollection);
    }


    public function get adPlaces():IMap {
        return _adPlaces;
    }

    /**
     *
     * @param uid
     * @return collection of ad places which parentUid equals uid
     */
    public function getAdPlacesByParentUid(uid:String):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < _adPlaces.getValues().length; i++) {
            var adPlace:AdPlaceVO = _adPlaces.getValues()[i];
            if (adPlace.parentUid == uid)ac.addItem(adPlace);
        }
        return ac;
    }

    public function set adPlaces(m:IMap):void {
        var entries:Array = m.getEntries();
        for (var i:int = 0; i < entries.length; i++) {
            var entry:HashMapEntry = entries[i];
            var key:String = entry.key;
            var adPlace:AdPlaceVO = entry.value;
            if (_adPlaces.containsKey(key)) {
                AdPlaceVO(_adPlaces.getValue(key)).mergeProperties(adPlace);
            } else {
                _adPlaces.put(key, adPlace);
            }
        }
    }

    /**
     *
     * @param label
     * @return collection of ad places which field label equals param label
     */
    public function getAdPlacesByLabel(label:String):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for each (var adPlace:AdPlaceVO in _adPlaces.getValues()) {
            if (adPlace.label == label) {
                ac.addItem(adPlace);
            }
        }
        return ac;
    }
}
}