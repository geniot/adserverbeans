package com.adserversoft.flexfuse.server.service;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 */
public class FreemarkerTextProcessor {
    Logger logger;
    private Configuration cfg = new Configuration();

    public FreemarkerTextProcessor() {
        cfg.setObjectWrapper(new DefaultObjectWrapper());
        cfg.setClassForTemplateLoading(this.getClass(), "/");
        cfg.setEncoding(Locale.ENGLISH, "UTF-8");
    }

    public void processTemplate(
            String templateName,
            Map<String, Object> params,
            PrintWriter printWriter) {
        try {
            Template temp = cfg.getTemplate(templateName);
            temp.process(params, printWriter);
            printWriter.flush();
            printWriter.close();
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }
    }

    public void processTemplateByContent(
            InputStream templateContents,
            Map<String, Object> params,
            PrintWriter printWriter) {
        try {
            Template temp = new Template("name", new InputStreamReader(templateContents), new Configuration());

            temp.process(params, printWriter);
            printWriter.flush();
            printWriter.close();
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage());
        }
    }

}
