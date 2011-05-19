package com.adserversoft.flexfuse.server.api.service;

import com.adserversoft.flexfuse.server.api.ReportCriteria;
import com.adserversoft.flexfuse.server.api.ReportsRow;

import java.util.List;

public interface IReportManagementService {
    public List<ReportsRow> loadReport(ReportCriteria reportRequest) throws Exception;

}