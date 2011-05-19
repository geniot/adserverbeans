package com.adserversoft.flexfuse.server.adserver;

import com.adserversoft.flexfuse.server.api.ApplicationConstants;
import org.springframework.web.context.ContextLoaderListener;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;


public class AdServerServlet extends HttpServlet {
    static Logger logger = Logger.getLogger(AdServerServlet.class.getName());
    private AdServerModelBuilder adServerModelBuilder;
    private AdCodeProcessor adCodeProcessor;
    private FileProcessor fileProcessor;
    private ClickProcessor clickProcessor;
    private Map<String, Set<Thread>> uniquesThreads = new HashMap<String, Set<Thread>>();
    private static int POLL_INTERVAL = 10;
    private static int MAX_WAIT = 1000;


    public void doGet(HttpServletRequest request, HttpServletResponse response) {
        try {
            ApplicationConstants.bustCache(response);
            RequestParametersForm requestParametersForm = adServerModelBuilder.buildParamsFromRequest(request, response);

            switch (requestParametersForm.getEventType()) {

                case ApplicationConstants.GET_AD_CODE_SERVER_EVENT_TYPE:
                    if (!uniquesThreads.containsKey(requestParametersForm.getUniqueId()))
                        uniquesThreads.put(requestParametersForm.getUniqueId(), new HashSet<Thread>());
                    Set<Thread> uniThreads = uniquesThreads.get(requestParametersForm.getUniqueId());
                    int wait = 0;
                    try {
                        while (!uniThreads.isEmpty() && wait < MAX_WAIT) {
                            Thread.sleep(POLL_INTERVAL);
                            wait += POLL_INTERVAL;
                        }
                        uniThreads.add(Thread.currentThread());
//                    logger.log(Level.INFO, "enter:" + System.currentTimeMillis() + ":uniqueid:" + requestParametersForm.getUniqueId());
                        adCodeProcessor.processRequest(requestParametersForm);
//                    logger.log(Level.INFO, "exit:" + System.currentTimeMillis() + ":uniqueid:" + requestParametersForm.getUniqueId());
                    } catch (Exception ex) {
                        logger.log(Level.SEVERE, ex.getMessage(), ex);
                    } finally {
                        uniThreads.remove(Thread.currentThread());
                        if (uniThreads.isEmpty()) uniquesThreads.remove(requestParametersForm.getUniqueId());
                    }
                    return;

                case ApplicationConstants.GET_AD_FILE_SERVER_EVENT_TYPE:
                    fileProcessor.processRequest(requestParametersForm);
                    return;

                case ApplicationConstants.CLICK_AD_SERVER_EVENT_TYPE:
                    clickProcessor.processRequest(requestParametersForm);
                    return;

                default:
                    logger.log(Level.SEVERE, "Unidentified event type:" + requestParametersForm.getEventType());
                    adCodeProcessor.processRequest(requestParametersForm);
                    return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.log(Level.SEVERE, e.getMessage());
        }
    }

    public void init() throws ServletException {
        adCodeProcessor = (AdCodeProcessor) ContextLoaderListener.getCurrentWebApplicationContext().getBean("adCodeProcessor");
        fileProcessor = (FileProcessor) ContextLoaderListener.getCurrentWebApplicationContext().getBean("fileProcessor");
        clickProcessor = (ClickProcessor) ContextLoaderListener.getCurrentWebApplicationContext().getBean("clickProcessor");
        adServerModelBuilder = (AdServerModelBuilder) ContextLoaderListener.getCurrentWebApplicationContext().getBean("adServerModelBuilder");
    }


}

