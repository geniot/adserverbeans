package com.adserversoft.flexfuse.client.model.vo
{


[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.AdFormat")]
public dynamic class AdFormatVO extends BaseVO
{
    public var id:int;
    public var adFormatName:String;
    public var width:int;
    public var height:int;
    public var _sort:Number;

    public function get shortAdFormatName():String {
        return width + "x" + height;
    }

}
}
