package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.ReportCriteria;
import com.adserversoft.flexfuse.server.api.ReportsRow;

import java.util.List;

public interface IReportDAO {

    public List<ReportsRow> getReport(ReportCriteria reportCriteria) throws Exception;
}