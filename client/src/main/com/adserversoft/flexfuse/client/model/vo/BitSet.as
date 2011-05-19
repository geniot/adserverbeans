package com.adserversoft.flexfuse.client.model.vo
{
import flash.utils.ByteArray;


public dynamic class BitSet
{
    private var _ba:ByteArray;

    public function BitSet(ba:ByteArray)
    {
        this._ba = ba;
    }

    public function setBit(pos:int, val:Boolean):void {
        var v:int = val == true ? 1 : 0;
        var posByte:int = Math.floor(pos / 8);
        var posBit:int = Math.floor(pos % 8);

        var oldByte:Number = _ba[posByte];
        oldByte = (((0xFF7F >> posBit) & oldByte) & 0x00FF);
        var newByte:Number = ((v << (8 - (posBit + 1))) | oldByte);
        _ba[posByte] = newByte;
    }

    public function getBit(pos:int):Boolean {
        //((buf)[(i)/8]>>(i)%8&1)
        var tmp1:int = Math.floor(pos / 8);
        var tmp2:int = Math.floor(pos % 8);
        var pow:int = Math.pow(2, tmp2);
        var b:Boolean = Boolean(_ba[tmp1] >> (8 - (tmp2 + 1)) & 0x0001);
        return b;
    }

    public function traceArray():String {
        var s:String = new String();
        for (var i:int = 0; i < _ba.length * 8; i++) {
            if (getBit(i)) {
                s = s.concat("1");
            } else {
                s = s.concat("0");
            }
        }
        return s;
    }

    public function get byteArray():ByteArray {
        return _ba;
    }
}
}