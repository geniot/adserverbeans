package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.AdEvent;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;


/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class ReporterModel {
    private static Logger logger = Logger.getLogger(ReporterModel.class.getName());

    private Map<Integer, List<AdEvent>> adEventsL = new HashMap<Integer, List<AdEvent>>();

    public void registerEvent(AdEvent eo) throws IOException {
        List<AdEvent> l = adEventsL.get(eo.getInstId());
        if (l == null) l = new ArrayList<AdEvent>();
        l.add(eo);
        adEventsL.put(eo.getInstId(), l);
    }

    public List<AdEvent> getAdEventsL(int iid) {
        return adEventsL.get(iid);
    }

    public void setAdEventsL(int iid, List<AdEvent> adEventsL) {
        this.adEventsL.put(iid, adEventsL);
    }
}