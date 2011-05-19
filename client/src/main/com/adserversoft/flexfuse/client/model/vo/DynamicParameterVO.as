package com.adserversoft.flexfuse.client.model.vo
{

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.DynamicParameter")]
public dynamic class DynamicParameterVO extends BaseVO
{
    public var id:Object;
    public var bannerUid:String;
    public var parameterName:String;
    public var parameterValue:String;
    public var regex:Boolean;

    public function DynamicParameterVO() {
    }


    public function get isRegexString():String {
        return regex ? "regex" : "pattern";
    }

    public function mergeProperties(dynamicParameter:DynamicParameterVO):void {
        id = dynamicParameter.id;
        parameterName = dynamicParameter.parameterName;
        parameterValue = dynamicParameter.parameterValue;
        regex = dynamicParameter.regex;
    }
}
}