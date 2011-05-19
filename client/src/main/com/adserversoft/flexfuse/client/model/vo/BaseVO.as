package com.adserversoft.flexfuse.client.model.vo {
import com.adserversoft.flexfuse.client.model.ApplicationConstants;

import flash.utils.ByteArray;

import mx.collections.ArrayCollection;

public dynamic class BaseVO {


    public function clone():* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(this);
        myBA.position = 0;
        return(myBA.readObject());
    }

    public static function clone(o:*):* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(o);
        myBA.position = 0;
        return(myBA.readObject());
    }

    public function cloneObject(o:*):* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(o);
        myBA.position = 0;
        return(myBA.readObject());
    }

    public static function array2collection(arr:Array):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < arr.length; i++) {
            ac.addItem(arr[i]);
        }
        return ac;
    }

    public static function collection2map(uidc:ArrayCollection, idFieldName:String):IMap {
        var m:IMap = new HashMap();
        if (uidc == null || uidc.length == 0)return m;
        for (var i:int = 0; i < uidc.length; i++) {
            var o:Object = uidc.getItemAt(i);
            var oid:Object = o[idFieldName];
            if (oid == null) {
                oid = ApplicationConstants.getNewUidForMap(m);
            }
            o[idFieldName] = oid;
            m.put(oid, o);
        }
        return m;
    }

    public static function generateBannerUidsByAdPlaceUidsCollection(values:Array):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < values.length; i++) {
            var banner:BannerVO = values[i] as BannerVO;
            if (banner.adPlaceUid != null) {
                ac.addItem(banner.uid + "x" + banner.adPlaceUid);
            }
        }
        return ac;
    }

    public static function extractBannerUidsArrayCollection(banners:ArrayCollection):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < banners.length; i++) {
            var banner:BannerVO = banners[i] as BannerVO;
            ac.addItem(banner.uid);
        }
        return ac;
    }

    public static function extractAdPlaceUidsArrayCollection(adPlaces:ArrayCollection):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < adPlaces.length; i++) {
            var adPlace:AdPlaceVO = adPlaces[i] as AdPlaceVO;
            ac.addItem(adPlace.uid);
        }
        return ac;
    }
}
}