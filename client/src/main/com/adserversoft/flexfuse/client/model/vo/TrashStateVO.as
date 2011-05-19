package com.adserversoft.flexfuse.client.model.vo
{
import mx.collections.ArrayCollection;

[Bindable]
[RemoteClass(alias="com.adserversoft.flexfuse.server.api.TrashState")]
public dynamic class TrashStateVO extends BaseVO
{
    public var trashedObjects:ArrayCollection;

}
}
