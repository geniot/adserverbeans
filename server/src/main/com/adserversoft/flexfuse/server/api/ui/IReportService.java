package com.adserversoft.flexfuse.server.api.ui;

import com.adserversoft.flexfuse.server.api.ReportCriteria;

public interface IReportService {
    public ServerResponse loadReport(ServerRequest serverRequest, ReportCriteria reportRequest);

    public ServerResponse loadCustomReport(ServerRequest serverRequest, ReportCriteria reportRequest);

    public ServerResponse setCustomObjectToSession(ServerRequest serverRequest, Object objectForSession);
}