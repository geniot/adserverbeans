package com.adserversoft.flexfuse.server.api;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import java.io.ByteArrayInputStream;
import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.ResultSet;
import java.util.*;
import java.util.logging.Logger;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class BaseEntity implements Serializable {
    static Logger logger = Logger.getLogger(BaseEntity.class.getName());

    /**
     * @param except
     * @return map where keys are column names and values are this instance's field values
     * @throws Exception
     */
    public SortedMap<String, Object> getFieldsMapExcept(String[] except) throws Exception {
        SortedMap<String, Object> m = new TreeMap<String, Object>();
        List<String> exceptL = Arrays.asList(except);
        Field[] fields = this.getClass().getDeclaredFields();
        for (Field field : fields) {
            String cn = ApplicationConstants.getColumnNameFromField(field);
            if (cn == null) continue;//field is not annotated with Column
            if (exceptL.contains(field.getName())) continue;
            field.setAccessible(true);
            Method method = getFieldsGetter(field);
            m.put(cn, method.invoke(this));
        }
        return m;
    }

    public SortedMap<String, Object> getFieldsMapByName(String[] fieldsName) throws Exception {
        SortedMap<String, Object> m = new TreeMap<String, Object>();
        List<String> fieldsNameL = Arrays.asList(fieldsName);
        Field[] fields = this.getClass().getDeclaredFields();
        for (Field field : fields) {
            String cn = ApplicationConstants.getColumnNameFromField(field);
            if (cn == null) continue;//field is not annotated with Column
            if (fieldsNameL.contains(field.getName())) {
                field.setAccessible(true);
                Method method = getFieldsGetter(field);
                m.put(cn, method.invoke(this));
            }
        }
        return m;
    }

    private Method getFieldsGetter(Field field) {
        Method[] methods = this.getClass().getDeclaredMethods();
        for (Method m : methods) {
            if (m.getName().toLowerCase().equals(("get" + field.getName()).toLowerCase())) return m;
        }
        return null;
    }

    public void mergePropertiesFromXML(String xml) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true); // never forget this!
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(new ByteArrayInputStream(xml.getBytes()));

        XPathFactory xpathFactory = XPathFactory.newInstance();
        XPath xpath = xpathFactory.newXPath();

        Field[] fields = this.getClass().getDeclaredFields();
        for (Field field : fields) {
            field.setAccessible(true);
            XPathExpression expr = xpath.compile("//" + field.getName() + "/text()");
            Object result = expr.evaluate(doc, XPathConstants.NODESET);
            NodeList nodes = (NodeList) result;
            if (nodes.getLength() > 0) {
                if (field.getType().equals(Integer.class)) {
                    field.set(this, Integer.parseInt(nodes.item(0).getNodeValue()));
                } else if (field.getType().equals(Boolean.class)) {
                    field.set(this, Boolean.parseBoolean(nodes.item(0).getNodeValue()));
                } else if (field.getType().equals(Date.class)) {
                    Date date = new Date(nodes.item(0).getNodeValue());
                    field.set(this, date);
                } else if (field.getType().equals(Boolean[].class)) {
                    field.set(this, booleanArrayFromString(nodes.item(0).getNodeValue()));
                } else {
                    field.set(this, nodes.item(0).getNodeValue());
                }
            }
        }
    }

    private Boolean[] booleanArrayFromString(String nodeValue) {
        StringTokenizer pars = new StringTokenizer(nodeValue, ",");
        Boolean[] res = new Boolean[24];
        for (int i = 0; i < 24; i++) {
            res[i] = new Boolean(pars.nextToken());
        }
        return res;
    }

    public void mergePropertiesFromResultRow(Map row) throws Exception {
        Field[] fields = this.getClass().getDeclaredFields();
        for (Field field : fields) {
            String cn = ApplicationConstants.getColumnNameFromField(field);
            if (cn == null) continue;//field is not annotated with Column, no save in DB
            field.setAccessible(true);
            field.set(this, row.get(cn));
        }
    }

    public void mergePropertiesFromResultSet(ResultSet rs) throws Exception {
        Field[] fields = this.getClass().getDeclaredFields();
        for (Field field : fields) {
            String cn = ApplicationConstants.getColumnNameFromField(field);
            if (cn == null) continue;//field is not annotated with Column
            try {
                field.setAccessible(true);
                if (field.getType().equals(Integer.class)) {
                    field.set(this, rs.getInt(cn));
                } else if (field.getType().equals(Boolean.class)) {
                    field.set(this, rs.getBoolean(cn));
                } else if (field.getType().equals(byte[].class)) {
                    field.set(this, rs.getBytes(cn));
                } else if (field.getType().equals(Date.class)) {
                    field.set(this, rs.getDate(cn));
                } else {
                    field.set(this, rs.getString(cn));
                }
            } catch (Exception e) {
//                logger.log(Level.SEVERE, e.getMessage());
                continue;
            }
        }
    }
}
