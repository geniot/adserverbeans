<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
           http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans-2.5.xsd">

<bean id="dataSource${INST_ID}" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
    <property name="driverClassName" value="${db_driver}"/>
    <property name="url" value="${db_url}"/>
    <property name="username" value="${db_username}"/>
    <property name="password" value="${db_password}"/>
</bean>

<bean id="transactionManager${INST_ID}"
      class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource">
        <ref local="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="geoTargetingDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.GeoTargetingDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="languageDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.LanguageDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="adEventDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.AdEventDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="bannerDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.BannerDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="userDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.UserDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="adPlaceDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.AdPlaceDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="settingsDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.SettingsDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="reportDAO${INST_ID}"
      class="com.adserversoft.flexfuse.server.dao.ReportDAO"
      autowire="byName">
    <property name="dataSource">
        <ref bean="dataSource${INST_ID}"/>
    </property>
</bean>

<bean name="reportManagementServiceTarget${INST_ID}"
      class="com.adserversoft.flexfuse.server.service.ReportManagementService"
      autowire="byName">
</bean>

<bean id="reportManagementService${INST_ID}"
      class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
    <property name="transactionManager">
        <ref bean="transactionManager${INST_ID}"/>
    </property>
    <property name="target">
        <ref bean="reportManagementServiceTarget${INST_ID}"/>
    </property>
    <property name="transactionAttributes">
        <props>
            <prop key="create*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="update*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="delete*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="load*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="*">PROPAGATION_REQUIRED,readOnly,-Exception</prop>
        </props>
    </property>
</bean>

<bean name="templatesManagementServiceTarget${INST_ID}"
      class="com.adserversoft.flexfuse.server.service.TemplatesManagementService"
      autowire="byName">
</bean>

<bean id="templatesManagementService${INST_ID}"
      class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
    <property name="transactionManager">
        <ref bean="transactionManager${INST_ID}"/>
    </property>
    <property name="target">
        <ref bean="templatesManagementServiceTarget${INST_ID}"/>
    </property>
    <property name="transactionAttributes">
        <props>
            <prop key="create*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="update*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="delete*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="*">PROPAGATION_REQUIRED,readOnly,-Exception</prop>
        </props>
    </property>
</bean>

<bean name="userManagementServiceTarget${INST_ID}"
      class="com.adserversoft.flexfuse.server.service.UserManagementService"
      autowire="byName">
</bean>

<bean id="userManagementService${INST_ID}"
      class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
    <property name="transactionManager">
        <ref bean="transactionManager${INST_ID}"/>
    </property>
    <property name="target">
        <ref bean="userManagementServiceTarget${INST_ID}"/>
    </property>
    <property name="transactionAttributes">
        <props>
            <prop key="create*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="update*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="delete*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="*">PROPAGATION_REQUIRED,readOnly,-Exception</prop>
        </props>
    </property>
</bean>

<bean name="stateManagementServiceTarget${INST_ID}"
      class="com.adserversoft.flexfuse.server.service.StateManagementService"
      autowire="byName">
</bean>

<bean id="stateManagementService${INST_ID}"
      class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
    <property name="transactionManager">
        <ref bean="transactionManager${INST_ID}"/>
    </property>
    <property name="target">
        <ref bean="stateManagementServiceTarget${INST_ID}"/>
    </property>
    <property name="transactionAttributes">
        <props>
            <prop key="create*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="update*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="delete*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="load*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="*">PROPAGATION_REQUIRED,readOnly,-Exception</prop>
        </props>
    </property>
</bean>

<bean name="bannerManagementServiceTarget${INST_ID}"
      class="com.adserversoft.flexfuse.server.service.BannerManagementService"
      autowire="byName">
</bean>

<bean id="bannerManagementService${INST_ID}"
      class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
    <property name="transactionManager">
        <ref bean="transactionManager${INST_ID}"/>
    </property>
    <property name="target">
        <ref bean="bannerManagementServiceTarget${INST_ID}"/>
    </property>
    <property name="transactionAttributes">
        <props>
            <prop key="create*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="update*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="delete*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="*">PROPAGATION_REQUIRED,readOnly,-Exception</prop>
        </props>
    </property>
</bean>

<bean name="mailManagementServiceTarget${INST_ID}"
      class="com.adserversoft.flexfuse.server.service.MailManagementService"
      autowire="byName">
</bean>

<bean id="mailManagementService${INST_ID}"
      class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
    <property name="transactionManager">
        <ref bean="transactionManager${INST_ID}"/>
    </property>
    <property name="target">
        <ref bean="mailManagementServiceTarget${INST_ID}"/>
    </property>
    <property name="transactionAttributes">
        <props>
            <prop key="create*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="update*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="delete*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="*">PROPAGATION_REQUIRED,readOnly,-Exception</prop>
        </props>
    </property>
</bean>

<bean name="settingsManagementServiceTarget${INST_ID}"
      class="com.adserversoft.flexfuse.server.service.SettingsManagementService"
      autowire="byName">
</bean>

<bean id="settingsManagementService${INST_ID}"
      class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
    <property name="transactionManager">
        <ref bean="transactionManager1"/>
    </property>
    <property name="target">
        <ref bean="settingsManagementServiceTarget${INST_ID}"/>
    </property>
    <property name="transactionAttributes">
        <props>
            <prop key="create*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="update*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="delete*">PROPAGATION_REQUIRED,-Exception</prop>
            <prop key="*">PROPAGATION_REQUIRED,readOnly,-Exception</prop>
        </props>
    </property>
</bean>

</beans>