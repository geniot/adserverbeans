package com.adserversoft.flexfuse.server.service;

import com.adserversoft.flexfuse.server.api.ReportCriteria;
import com.adserversoft.flexfuse.server.api.ReportsRow;
import com.adserversoft.flexfuse.server.api.service.IReportManagementService;

import java.util.List;

public class ReportManagementService extends AbstractManagementService implements IReportManagementService {

    public List<ReportsRow> loadReport(ReportCriteria reportRequest) throws Exception {
        return getReportDAO().getReport(reportRequest);
    }
}