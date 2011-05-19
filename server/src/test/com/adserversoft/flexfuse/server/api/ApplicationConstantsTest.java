package com.adserversoft.flexfuse.server.api;

import junit.framework.TestCase;

import java.util.Random;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class ApplicationConstantsTest extends TestCase {

    public void testMirror() {
        Random r = new Random();
        for (int i = 0; i < 100; i++) {
            String rnd = String.valueOf(r.nextLong());
            String mirror = ApplicationConstants.mirrorBytes(rnd);
            assertEquals(rnd, ApplicationConstants.mirrorBytes(mirror));
        }
    }
}
