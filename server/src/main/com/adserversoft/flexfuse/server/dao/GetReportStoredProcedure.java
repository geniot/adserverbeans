package com.adserversoft.flexfuse.server.dao;

import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.StoredProcedure;

import javax.sql.DataSource;
import java.sql.Types;

public class GetReportStoredProcedure extends StoredProcedure {
    public GetReportStoredProcedure(DataSource ds) {
        setDataSource(ds);
        setSql("get_report_proc");
        declareParameter(new SqlParameter("type_in", Types.INTEGER));
        declareParameter(new SqlParameter("from_date_time_in", Types.TIMESTAMP));
        declareParameter(new SqlParameter("to_date_time_in", Types.TIMESTAMP));
        declareParameter(new SqlParameter("precision_in", Types.INTEGER));
        declareParameter(new SqlParameter("uids_in", Types.VARCHAR));
        compile();
    }
}