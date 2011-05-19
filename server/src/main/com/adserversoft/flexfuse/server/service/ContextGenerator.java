package com.adserversoft.flexfuse.server.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Reads app.properties, recreates applicationContext-service.xml and applicationContext-serviceN.xml files.
 * <p/>
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class ContextGenerator {
    private FreemarkerTextProcessor freemarkerTextProcessor = new FreemarkerTextProcessor();

    private static String HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
            "\n" +
            "<beans xmlns=\"http://www.springframework.org/schema/beans\"\n" +
            "       xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n" +
            "       xsi:schemaLocation=\"\n" +
            "           http://www.springframework.org/schema/beans\n" +
            "           http://www.springframework.org/schema/beans/spring-beans-2.5.xsd\">\n";

    private static String FOOTER = "</beans>";

    public ContextGenerator() {
        try {
            Properties props = new Properties();
            InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
            props.load(is);

            FileOutputStream fos = new FileOutputStream("server/src/main/context/applicationContext-service.xml");
            fos.write(HEADER.getBytes());
            fos.write(generateImports(props.getProperty("db.count")).getBytes());
            fos.write(FOOTER.getBytes());
            fos.flush();
            fos.close();

            //removing files server/src/main/context/applicationContext-serviceN.xml
            File f = new File("server/src/main/context");
            File[] files = f.listFiles();
            for (File file : files) {
                if (file.getName().startsWith("applicationContext-inst-") && file.getName().endsWith(".xml")) {
                    file.delete();
                }
            }

            //recreating inst-N context files
            Integer dbCount = Integer.parseInt(props.getProperty("db.count"));
            for (int i = 0; i < dbCount; i++) {
                Map<String, Object> paramsMap = new HashMap();
                paramsMap.put("INST_ID", i + 1);
                for (Object key : props.keySet()) {
                    paramsMap.put(key.toString(), props.getProperty(key.toString()).replaceAll("\\$\\{instId\\}", String.valueOf(i + 1)));
                }

                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                PrintWriter printWriter = new PrintWriter(baos);
                freemarkerTextProcessor.processTemplate("templates/applicationContext-template.ftl", paramsMap, printWriter);
                String previewStr = new String(baos.toByteArray());

                FileOutputStream fileOutputStream = new FileOutputStream("server/src/main/context/applicationContext-inst-" + (i + 1) + ".xml");
                fileOutputStream.write(previewStr.getBytes());
                fos.flush();
                fos.close();
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void main(String[] args) {
        new ContextGenerator();
    }

    private static String generateImports(String property) {
        Integer dbCount = Integer.parseInt(property);
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < dbCount; i++) {
            sb.append("<import resource=\"applicationContext-inst-");
            sb.append(i + 1);
            sb.append(".xml\"></import>\n");
        }
        return sb.toString();
    }
}
