<script type="text/javascript">
    document.writeln('<iframe src="${ADSOURCE_ID_REQUEST_PARAM_KEY}" width="${WIDTH_REQUEST_PARAM_KEY}" height="${HEIGHT_REQUEST_PARAM_KEY}" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>');

    function listener(event){
        <#--alert(event.origin + " test " + "${TARGETURL_REQUEST_PARAM_KEY}");-->
	<#--if ( event.origin !== "${TARGETURL_REQUEST_PARAM_KEY}" )-->
		<#--return;-->
        var req = getXmlHttp();
        req.open('GET', "${TARGETURL_REQUEST_PARAM_KEY}", true);
        req.send(null);
    }

    function getXmlHttp(){
        var xmlhttp;
        try {
            xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (E) {
                xmlhttp = false;
            }
        }
        if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
            xmlhttp = new XMLHttpRequest();
        }
        return xmlhttp;
    }

    if (window.addEventListener){
        window.addEventListener("message", listener, false);
    } else {
        window.attachEvent("onmessage", listener);
    }
</script>