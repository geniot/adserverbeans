package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.User;
import com.adserversoft.flexfuse.server.api.service.IMailManagementService;
import com.adserversoft.flexfuse.server.api.ui.ServerRequest;
import com.adserversoft.flexfuse.server.dao.InstallationContextHolder;
import flex.messaging.FlexContext;

import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Author: Dmitrii Lemeshevsky
 * 22.02.2010 15:09:52
 */
public class MailManagementService extends AbstractManagementService implements IMailManagementService {
    static Logger logger = Logger.getLogger(TemplatesManagementService.class.getName());
    private FreemarkerTextProcessor freemarkerTextProcessor = new FreemarkerTextProcessor();
    private Properties appProperties;

    public MailManagementService() {
        try {
            appProperties = new Properties();
            InputStream is = this.getClass().getClassLoader().getResourceAsStream("app.properties");
            appProperties.load(is);
        } catch (Exception ex) {
            logger.log(Level.SEVERE, ex.getMessage(), ex);
        }
    }

    @Override
    public String getPasswordResetEmailContent(User currentUser) {
        Map<String, Object> paramsMap = new HashMap<String, Object>();
        if (currentUser.getFirstName() != null && currentUser.getLastName() != null) {
            paramsMap.put("firstName", currentUser.getFirstName());
            paramsMap.put("lastName", currentUser.getLastName());
        } else if (currentUser.getFirstName() != null) {
            paramsMap.put("firstName", currentUser.getFirstName());
            paramsMap.put("lastName", "");
        } else if (currentUser.getLastName() != null) {
            paramsMap.put("firstName", "");
            paramsMap.put("lastName", currentUser.getLastName());
        } else {
            paramsMap.put("firstName", "Dear");
            paramsMap.put("lastName", "customer");
        }

        String passwordResetCode = UUID.randomUUID().toString().substring(24, 36);
        String passwordResetCode_hash = BCrypt.hashpw(passwordResetCode, BCrypt.gensalt());
        paramsMap.put("resetPasswordCode", passwordResetCode);
        paramsMap.put("email", currentUser.getEmail());
        paramsMap.put("supportEmail", currentUser.getSupportEmail());
        paramsMap.put("mailUrlFirst", appProperties.getProperty("mail.urlFirst"));
        String url = FlexContext.getHttpRequest().getRequestURL().toString().split(FlexContext.getHttpRequest().getRequestURI())[0] + FlexContext.getHttpRequest().getContextPath();
        paramsMap.put("mailUrlSecond", url + appProperties.getProperty("mail.urlSecond"));
        paramsMap.put("mailUrlThird", appProperties.getProperty("mail.urlThird"));
        paramsMap.put("mailUrlForth", appProperties.getProperty("mail.urlForth"));
        paramsMap.put("userId", currentUser.getId());
        paramsMap.put("installationId", InstallationContextHolder.getCustomerType().intValue());


        currentUser.setResetCode(passwordResetCode_hash);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintWriter printWriter = new PrintWriter(baos);
        freemarkerTextProcessor.processTemplate(appProperties.getProperty("template.path.reset"), paramsMap, printWriter);
        return new String(baos.toByteArray());
    }


    @Override
    public void sendEmail(String emailText, String emailSubject, String emailAddress, User currentUser) throws Exception {
        try {
            Properties props = System.getProperties();
            props.put("mail.smtp.host", currentUser.getSmtpServer());
            props.put("mail.smtp.port", currentUser.getPort());
            final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
            props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
            props.setProperty("mail.smtp.socketFactory.fallback", "false");
            props.setProperty("mail.smtp.auth", "true");
            Session session = Session.getDefaultInstance(props, null);
            session.setDebug(true); // Verbose!

            Message currentMessage = new MimeMessage(session);
            currentMessage.setFrom(new InternetAddress(currentUser.getFromEmail()));
            currentMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(emailAddress));
            currentMessage.setSubject(emailSubject);

            BodyPart messageBodyPart = new MimeBodyPart();
            System.out.println(emailText);
            messageBodyPart.setContent(emailText, "text/html");
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(messageBodyPart);
            currentMessage.setContent(multipart);
            currentMessage.setText(emailText);
            Transport transport = session.getTransport("smtp");
            transport.connect(currentUser.getFromEmail(), currentUser.getSmtpUser(), currentUser.getSmtpPassword());
            currentMessage.saveChanges();
            transport.sendMessage(currentMessage, currentMessage.getAllRecipients());
            transport.close();
//            Transport.send(currentMessage);
        } catch (Exception ex) {
            throw new Exception("failure.sendmail");
        }
    }
}
