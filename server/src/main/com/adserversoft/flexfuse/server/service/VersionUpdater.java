package com.adserversoft.flexfuse.server.service;

import java.io.FileInputStream;
import java.io.FileOutputStream;

/**
 * Updates minor version in ApplicationConstants in server and client modules.
 * <p/>
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class VersionUpdater {
    public static String MAJOR = "0.6.";

    public static String PREFIX1 = "public static String VERSION = \"";
    public static String PREFIX2 = "public static var VERSION:String = \"";

    public static String PATH1 = "server/src/main/com/adserversoft/flexfuse/server/api/ApplicationConstants.java";
    public static String PATH2 = "client/src/main/com/adserversoft/flexfuse/client/model/ApplicationConstants.as";

    public VersionUpdater() {
        try {
            FileInputStream fis = new FileInputStream(PATH1);
            byte[] bbs = new byte[fis.available()];
            fis.read(bbs);
            fis.close();
            String f = new String(bbs);
            int ind1 = f.indexOf(PREFIX1) + PREFIX1.length();
            int ind2 = f.indexOf("\"", ind1);
            String currentVersion = f.substring(ind1, ind2);
            String minor = currentVersion.substring(currentVersion.lastIndexOf(".") + 1, currentVersion.length());
            String newVersion = MAJOR + (Integer.parseInt(minor) + 1);
            f = f.replaceFirst(PREFIX1 + currentVersion, PREFIX1 + newVersion);
            FileOutputStream fos = new FileOutputStream(PATH1);
            fos.write(f.getBytes("utf8"));
            fos.close();

            //client
            fis = new FileInputStream(PATH2);
            bbs = new byte[fis.available()];
            fis.read(bbs);
            fis.close();
            f = new String(bbs);
            ind1 = f.indexOf(PREFIX2) + PREFIX2.length();
            ind2 = f.indexOf("\"", ind1);
            currentVersion = f.substring(ind1, ind2);
            f = f.replaceFirst(PREFIX2 + currentVersion, PREFIX2 + newVersion);
            fos = new FileOutputStream(PATH2);
            fos.write(f.getBytes("utf8"));
            fos.close();


        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void main(String[] args) {
        new VersionUpdater();
    }

}
