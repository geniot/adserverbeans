package com.adserversoft.flexfuse.client.model {
import com.adserversoft.flexfuse.client.ApplicationFacade;
import com.adserversoft.flexfuse.client.model.vo.AdFormatVO;
import com.adserversoft.flexfuse.client.model.vo.BaseVO;
import com.adserversoft.flexfuse.client.model.vo.HashMap;
import com.adserversoft.flexfuse.client.model.vo.IMap;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.core.Application;
import mx.formatters.CurrencyFormatter;
import mx.resources.IResourceBundle;
import mx.resources.ResourceManager;

import org.puremvc.as3.interfaces.IFacade;
import org.puremvc.as3.patterns.facade.Facade;

[Bindable]
public class ApplicationConstants extends Facade implements IFacade {
    public static var VERSION:String = "0.6.2";
    public static const APP_RES:String = "ApplicationResource";
    public static const INSTALLATION_ID_PARAM:String = "instId";
    public static const DEFAULT_INSTALLATION_ID:int = 1;

    public static const STARTUP:String = "STARTUP";

    public static const SESSION_EXPIRED:String = "SESSION_EXPIRED";
    public static const VERSION_EXPIRED:String = "VERSION_EXPIRED";

    public static const CREATE:String = "CREATE";
    public static const EDIT:String = "EDIT";

    public static const RELOGIN:String = "RELOGIN";

    public static const SERVER_FAULT:String = "SERVER_FAULT";

    public static const FAILURE:String = "FAILURE";
    public static const SUCCESS:String = "SUCCESS";
    public static const DB_FAILURE:String = "DB_FAILURE";

    public static const LOCALE_UPDATED:String = "LOCALE_UPDATED";
    public static const SETTINGS_LOADED:String = "SETTINGS_LOADED";

    public static const BALANCE_LOADED:String = "BALANCE_LOADED";

    public static const BANNER_ADDED:String = "BANNER_ADDED";
    public static const BANNER_REMOVED:String = "BANNER_REMOVED";
    public static const BANNER_UPDATED:String = "BANNER_UPDATED";

    public static const AD_PLACE_REMOVED:String = "AD_PLACE_REMOVED";
    public static const AD_ITEM_REMOVED:String = "AD_ITEM_REMOVED";
    public static const AD_ITEMS_REMOVED:String = "AD_ITEMS_REMOVED";

    public static const BANNER_FILE_SELECTED:String = "BANNER_FILE_SELECTED";
    public static const BANNER_FILE_TOO_BIG:String = "BANNER_FILE_TOO_BIG";
    public static const BANNER_FILE_UPLOADED:String = "BANNER_FILE_UPLOADED";

    public static const STATE_CHANGED:String = "STATE_CHANGED";
    public static const STATE_SAVED:String = "STATE_SAVED";
    public static const STATE_LOADED:String = "STATE_LOADED";
    public static const STATE_INVALID:String = "STATE_INVALID";
    public static const STATE_VALID:String = "STATE_VALID";

    public static const TRASH_STATE_LOADED:String = "TRASH_STATE_LOADED";

    public static const REPORT_LOADED:String = "REPORT_LOADED";
    public static const CUSTOM_REPORT_LOAD:String = "CUSTOM_REPORT_LOAD";
    public static const CUSTOM_REPORT_LOADED:String = "CUSTOM_REPORT_LOADED";
    public static const CUSTOM_OBJECT_SET_TO_SESSION:String = "CUSTOM_OBJECT_SET_TO_SESSION";

    public static const USER_LOGGED_IN:String = "USER_LOGGED_IN";
    public static const USER_LOGGED_OUT:String = "USER_LOGGED_OUT";
    public static const RESET_PASSWORD_SUCCESS:String = "RESET_PASSWORD_SUCCESS";
    public static const NEW_PASSWORD_SET:String = "NEW_PASSWORD_SET";

    public static const USER_LOGOUT_FAILED:String = "USER_LOGOUT_FAILED";
    public static const USER_LOGIN_FAILED:String = "USER_LOGIN_FAILED";

    public static const USER_PASSWORD_RESET_SENT:String = "PASSWORD_REMINDED";
    public static const EMAIL_REMINDED:String = "EMAIL_REMINDED";

    public static const SETTINGS_UPDATED:String = "SETTINGS_UPDATED";

    public static const RESET_CODE_OUTDATED:String = "RESET_CODE_OUTDATED";
    public static const RESET_CODE_NOT_CORRECT:String = "RESET_CODE_NOT_CORRECT";

    public static const TW_RESET_PASSWORD_CLOSED:String = "TW_RESET_PASSWORD_CLOSED";
    public static const TW_REMIND_PASSWORD_CLOSED:String = "TW_REMIND_PASSWORD_CLOSED";

    public static const UPLOAD_ACTION_BANNER:String = "saveBannerToDB";
    public static const UPLOAD_ACTION_LOGO:String = "saveLogoToSession";

    public static const REPORT_VIEW_TABLE:String = "REPORT_VIEW_TABLE";
    public static const REPORT_VIEW_CHART:String = "REPORT_VIEW_CHART";
    public static const REPORT_VIEW_BY_TYPE:String = "REPORT_VIEW_BY_TYPE";
    public static const REPORT_VIEW_BY_DATE:String = "REPORT_VIEW_BY_DATE";
    public static const REPORT_WINDOW_CLOSED:String = "REPORT_WINDOW_CLOSED";

    public static const MAX_CHARS:int = 250;

    public static const SUNDAY:int = 0;
    public static const MONDAY:int = 1;
    public static const TUESDAY:int = 2;
    public static const WEDNESDAY:int = 3;
    public static const THURSDAY:int = 4;
    public static const FRIDAY:int = 5;
    public static const SATURDAY:int = 6;

    public static const AD_FORMATS:IMap = new HashMap();
    public static const PERIOD:ArrayCollection = new ArrayCollection();
    public static const PRECISION:ArrayCollection = new ArrayCollection();
    public static const DISPLAY:ArrayCollection = new ArrayCollection();

    public static const LOGO_FILE_SELECTED:String = "LOGO_FILE_SELECTED";
    public static const LOGO_FILE_TOO_BIG:String = "LOGO_FILE_TOO_BIG";
    public static const LOGO_UPLOADED:String = "LOGO_UPLOADED";

    public static const APPLICATION_CONTROL_BAR_HEIGHT:int = 40;
    public static const TITLE_WIDTH:int = 1000;
    public static const TITLE_HEIGHT:int = 716;
    public static const ROW_HEIGHT:int = 27;
    public static const HEADER_HEIGHT:int = 22;
    public static const DURATION:int = 200;

    public static const STATE_ACTIVE:int = 1;
    public static const STATE_INACTIVE:int = 2;
    public static const STATE_REMOVED:int = 3;

    public static const ALPHA_ACTIVE:Number = 1.0;
    public static const ALPHA_INACTIVE:Number = 0.5;

    public static const IMAGE_BANNER_CONTENT_TYPE_ID:int = 1;
    public static const FLASH_BANNER_CONTENT_TYPE_ID:int = 2;
    public static const HTML_BANNER_CONTENT_TYPE_ID:int = 3;
    public static const AD_TAG_BANNER_CONTENT_TYPE_ID:int = 4;
    public static const IMAGE_BANNER_CONTENT_TYPE_FILE:String = "*.jpg, *.jpeg, *.gif, *.png";
    public static const FLASH_BANNER_CONTENT_TYPE_FILE:String = "*.swf";
    public static const HTML_BANNER_CONTENT_TYPE_FILE:String = "*.html, *.htm, *.txt";

    public static const GET_AD_TAG_SERVER_EVENT_TYPE:int = 1;

    public static const BANNER_UID:String = "bannerUid";
    public static const BANNER_PARENT_UID:String = "bannerParentUid";
    public static const AD_FORMAT_ID:String = "adFormatId";
    public static const BANNER_CONTENT_TYPE:String = "bannerContentType";

    public static const REPORTS_TIMER_INTERVAL:int = 10000;
    public static const REQUEST_TIMEOUT_SECONDS:int = 60;

    public static const MORNING_RANGE:Array = [5,6,7,8,9,10,11];
    public static const AFTERNOON_RANGE:Array = [12,13,14,15,16,17];
    public static const EVENING_RANGE:Array = [18,19,20,21];
    public static const NIGHT_RANGE:Array = [22,23,0,1,2,3,4];
    public static const HOURS_RANGE:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];
    public static const BANNER_FRAME_TARGETING:Array = ["new","same"];

    public static const SELECTED_ALL:int = 0;
    public static const SELECTED_SOME:int = 1;
    public static const SELECTED_NONE:int = 2;


    public static const REPORT_TYPE_WHOLE:int = 0;
    public static const REPORT_TYPE_BANNERS:int = 1;
    public static const REPORT_TYPE_AD_PLACES:int = 2;
    public static const REPORT_TYPE_BANNER_ON_AD_PLACES:int = 3;

    //type precision for reports
    public static const  NONE_PRECISION:int = -1;
    public static const  HOUR_PRECISION:int = 0;
    public static const  DAY_PRECISION:int = 1;
    public static const  MONTH_PRECISION:int = 2;
    public static const  YEAR_PRECISION:int = 3;


    public static const  DELETE_PATTERN:String = "DELETE_PATTERN";


    public static function initializeDataProvider():void {
        initializeAdFormats();
        initializeDataProviderByLabelField(ApplicationConstants.PERIOD, "period");
        initializeDataProviderByLabelField(ApplicationConstants.PRECISION, "precision");
        initializeDataProviderByLabelField(ApplicationConstants.DISPLAY, "display");
    }

    public static function initializeDataProviderByLabelField(ac:ArrayCollection, labelField:String):ArrayCollection {
        var resourceBundle:IResourceBundle = ResourceManager.getInstance().getResourceBundle("en_US", "ApplicationResource");
        for (var key:String in resourceBundle.content) {
            if (key.indexOf(labelField + ".") == 0) {
                var object:Object = new Object();
                object["id"] = key.split(".")[1];
                object[labelField] = ResourceManager.getInstance().getString('ApplicationResource', key);
                ac.addItem(object);
            }
        }
        var sort:Sort = new Sort();
        sort.fields = [new SortField("id", true)];
        ac.sort = sort;
        ac.refresh();
        return ac;
    }

    private static function initializeAdFormats():void {
        var rb:IResourceBundle = ResourceManager.getInstance().getResourceBundle("en_US", "ApplicationResource");
        for (var key:String in rb.content) {
            if (key.indexOf("ad_format.") == 0) {
                var adFormat:AdFormatVO = new AdFormatVO();
                adFormat.id = key.split(".")[1];
                adFormat.adFormatName = ResourceManager.getInstance().getString('ApplicationResource', key);
                adFormat.width = int(key.split(".")[2].split("_")[0]);
                adFormat.height = int(key.split(".")[2].split("_")[1]);
                ApplicationConstants.AD_FORMATS.put(adFormat.id, adFormat);
            }
        }
    }

    public static function get sortedAdFormatsCollection():ArrayCollection {
        var ac:ArrayCollection = BaseVO.array2collection(AD_FORMATS.getValues());
        var dataSortFieldWidth:SortField = new SortField();
        dataSortFieldWidth.name = "width";
        dataSortFieldWidth.numeric = true;
        var dataSortFieldHeight:SortField = new SortField();
        dataSortFieldHeight.name = "height";
        dataSortFieldHeight.numeric = true;
        var numericDataSort:Sort = new Sort();
        numericDataSort.fields = [dataSortFieldWidth,dataSortFieldHeight];
        ac.sort = numericDataSort;
        ac.refresh();
        return ac;
    }

    public static function deleteWhiteSpaces(name:String):String {
        return name.replace(/^\s+|\s+$/g, '');
    }

    public static function getBannerContentTypeIdByFileType(fileType:String):int {
        var pattern:RegExp = /[.](jpeg)|(jpg)|(gif)|(png)$/;
        var result:Object = pattern.exec(fileType);
        if (result != null) {
            return ApplicationConstants.IMAGE_BANNER_CONTENT_TYPE_ID;
        } else {
            pattern = /[.](swf)$/;
            result = pattern.exec(fileType);
            if (result != null) {
                return ApplicationConstants.FLASH_BANNER_CONTENT_TYPE_ID;
            } else {
                pattern = /[.](html)|(htm)|(txt)$/;
                result = pattern.exec(fileType);
                if (result != null) {
                    return ApplicationConstants.HTML_BANNER_CONTENT_TYPE_ID;
                } else {
                    return ApplicationConstants.IMAGE_BANNER_CONTENT_TYPE_ID;
                }
            }
        }
    }

    public static function getFileType(filename:String):String {
        var pattern:RegExp = /[^\.]+$/gim;
        var result:Object = pattern.exec(filename);
        return String(result);
    }

    public static function get application():Object {
        return Application.application.hasOwnProperty("loader") ?
                Application.application.loader.content.application :
                Application.application;
    }

    public static function initBits(bitCount:int, value:Boolean):String {
        var s:String = "";
        for (var i:int = 0; i < bitCount; i++) {
            s += value ? "1" : "0";
        }
        return s;
    }

    public static function getRangeName(checkBoxId:int):String {
        var i:int;
        for (i = 0; i < MORNING_RANGE.length; i++) {
            if (MORNING_RANGE[i] == checkBoxId) {
                return "MORNING_RANGE";
            }
        }
        for (i = 0; i < AFTERNOON_RANGE.length; i++) {
            if (AFTERNOON_RANGE[i] == checkBoxId) {
                return "AFTERNOON_RANGE";
            }
        }
        for (i = 0; i < EVENING_RANGE.length; i++) {
            if (EVENING_RANGE[i] == checkBoxId) {
                return "EVENING_RANGE";
            }
        }
        for (i = 0; i < NIGHT_RANGE.length; i++) {
            if (NIGHT_RANGE[i] == checkBoxId) {
                return "NIGHT_RANGE";
            }
        }
        return "";
    }

    public static function changedState():void {
        ApplicationFacade.getInstance().sendNotification(ApplicationConstants.STATE_CHANGED, true);
    }

    public static function getNewUid():String {
        var str:String = Math.random().toString();
        return (String)(new Date().getTime()) + str.split(".")[1];
    }

    public static function getNewUidForMap(m:IMap):String {
        var uid:String = getNewUid();
        while (m.containsKey(uid))uid = getNewUid();
        return uid;
    }

    public static function currencyFormat(obj:Object, currencySymbol:String):String {
        var formatter:CurrencyFormatter = new CurrencyFormatter();
        formatter.precision = 2;
        formatter.rounding = "none";
        formatter.decimalSeparatorTo = ".";
        formatter.thousandsSeparatorTo = ",";
        formatter.useThousandsSeparator = true;
        formatter.currencySymbol = currencySymbol;
        return formatter.format(obj);
    }
}
}
