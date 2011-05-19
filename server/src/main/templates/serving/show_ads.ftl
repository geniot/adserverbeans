if (window.asb_pl_id==null){
    window.asb_pl_id=Math.floor(Math.random() * 1E16);
}

var asb_rdn = Math.floor(Math.random() * 1E16);
var asb_maxl = 400;
var asb_title = '';
var asb_kw = '';
var asb_placeUid = "${asb_place_uid}";
var asb_instId = "${asb_inst_id}";
var asb_count = "${asb_count}";
var asb_width = "${asb_width}";
var asb_height = "${asb_height}";

var asb_ad_format_id = "${asb_ad_format_id}";
var asb_banner_content_type = "${asb_banner_content_type}";
var asb_banner_uid = "${asb_banner_uid}";
var asb_custom_parameters = "${asb_custom_parameters}";

try {
    asb_title = (document.title ? document.title.substring(0, asb_maxl) : '');
    var asb_eles = document.getElementsByTagName('meta');
    for (var i = 0, ele; ele = asb_eles[i]; i++) {
        if (ele.name == 'keywords') {
            asb_kw = (ele.content ? ele.content.substring(0, asb_maxl) : '');
        }
    }
} catch (ex) {
}

var params = 'eventId=1' +
'&placeUid=' + asb_placeUid +
'&instId=' + asb_instId +
'&count=' + asb_count +
'&rnd=' + asb_rdn +
'&adFormatId=' + asb_ad_format_id +
'&bannerContentType=' + asb_banner_content_type +
'&bannerUid=' + asb_banner_uid +
'&wlpru=' + escape(document.referrer) +
'&wlpu=' + escape(window.location.href) +
'&wlpt=' + escape(document.title) +
'&wlpkw=' + escape(asb_kw) +
'&plId=' + window.asb_pl_id +
'&asb_custom_parameters=' + asb_custom_parameters;

var src = "${asb_url}";

var ifrm = document.createElement("IFRAME");
ifrm.setAttribute("src", src + "?" + params);
ifrm.setAttribute("id", "asb_id_" + asb_placeUid);
ifrm.setAttribute("frameborder", "0");

ifrm.style.width = asb_width + "px";
ifrm.style.height = asb_height + "px";
ifrm.marginHeight = "0";
ifrm.marginWidth = "0";
ifrm.scrolling = "no";


document.getElementById("asb_" + asb_placeUid).appendChild(ifrm);

if(typeof window.addEventListener != 'undefined') { //gecko
    window.addEventListener('load', adsense_init, false);
} else if(typeof document.addEventListener != 'undefined') { //opera 7
    document.addEventListener('load', adsense_init, false);
} else if(typeof window.attachEvent != 'undefined') { //ie
    window.attachEvent('onload', adsense_init);
} else { //older browsers
    if(typeof window.onload == 'function') { //mac/ie5
        var existing = onload;
        window.onload = function() {
            existing();
            adsense_init();
        };
    } else {
        window.onload = adsense_init;
    }
}

function adsense_init () {
    var ie = /*@cc_on!@*/false;
    if (ie) {  //ie
        var el = document.getElementsByTagName("iframe");
        for(var i = 0; i < el.length; i++) {
            if(el[i].id.indexOf('asb_id_') > -1) {
                el[i].onfocus =  function() {
                    as_click(el[i]);
                }
            }
        }
    } else { //firefox
        window.addEventListener('beforeunload', doPageExit, false);
        window.addEventListener('mousemove', getMouse, true);
    }
}

//begin for firefox
var px;
var py;

function getMouse(e) {
    if (typeof e.pageX  == 'number') { // most browsers
        px = e.pageX;
        py = e.pageY;
    } else if (typeof e.clientX  == 'number') { // ie
        px = e.clientX;
        py = e.clientY;
        if (document.body && (document.body.scrollLeft || document.body.scrollTop)) { // ie 4, 5 & 6 (in non-standards compliant mode)
            px += document.body.scrollLeft;
            py += document.body.scrollTop;
        } else if (document.documentElement && (document.documentElement.scrollLeft || document.documentElement.scrollTop )) { // ie 6 (in standards compliant mode)
            px += document.documentElement.scrollLeft;
            py += document.documentElement.scrollTop;
        }
    }
}

function findY(obj) {
    var y = 0;
    while (obj) {
        y += obj.offsetTop;
        obj = obj.offsetParent;
    }
    return(y);
}

function findX(obj) {
    var x = 0;
    while (obj) {
        x += obj.offsetLeft;
        obj = obj.offsetParent;
    }
    return(x);
}

function doPageExit(e) {
    var ad = document.getElementsByTagName("iframe");
    if (typeof px == 'undefined') {
        return;
    }
    for (i=0; i<ad.length; i++) {
        if(ad[i].id.indexOf('asb_id_') > -1) {
            var adLeft = findX(ad[i]);
            var adTop = findY(ad[i]);
            var inFrameX = (px > (adLeft - 10) && px < (parseInt(adLeft) + parseInt(ad[i].style.width) + 15));
            var inFrameY = (py > (adTop - 10) && py < (parseInt(adTop) + parseInt(ad[i].style.height) + 10));
            if (inFrameY && inFrameX) {
                as_click(ad[i]);
            }
        }
    }
}
//end for firefox

function as_click(targetIframe) {
    targetIframe.contentWindow.postMessage("asb_id_" + asb_placeUid, targetIframe.src);
}


