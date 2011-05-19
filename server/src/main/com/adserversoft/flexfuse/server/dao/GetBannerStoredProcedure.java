package com.adserversoft.flexfuse.server.dao;

import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.object.StoredProcedure;

import javax.sql.DataSource;
import java.sql.Types;

/**
 * Author: Vitaly Sazanovich
 * Email: Vitaly.Sazanovich@gmail.com
 * http://adserversoft.com
 */
public class GetBannerStoredProcedure extends StoredProcedure {
    public GetBannerStoredProcedure(DataSource ds) {
        setDataSource(ds);
        setSql("get_banner_proc_wrapper");
        //in
        declareParameter(new SqlParameter("ad_place_uid", Types.VARCHAR));
        declareParameter(new SqlParameter("now_date_time", Types.TIMESTAMP));
        declareParameter(new SqlParameter("ip", Types.BIGINT));
        declareParameter(new SqlParameter("unique_uid_in", Types.VARCHAR));
        declareParameter(new SqlParameter("time_stamp_long_in", Types.BIGINT));
        declareParameter(new SqlParameter("browser", Types.INTEGER));
        declareParameter(new SqlParameter("os_in", Types.INTEGER));
        declareParameter(new SqlParameter("language_in", Types.VARCHAR));
        declareParameter(new SqlParameter("banner_url", Types.VARCHAR));
        declareParameter(new SqlParameter("referrer_in", Types.VARCHAR));
        declareParameter(new SqlParameter("page_load_id", Types.VARCHAR));
        declareParameter(new SqlParameter("dynamic_parameters_in", Types.VARCHAR));

        //out
        declareParameter(new SqlOutParameter("banner_uid", Types.VARCHAR));
        declareParameter(new SqlOutParameter("ad_format_id", Types.INTEGER));
        declareParameter(new SqlOutParameter("banner_content_type_id", Types.INTEGER));
        declareParameter(new SqlOutParameter("unique_uid_out", Types.VARCHAR));
        declareParameter(new SqlOutParameter("frame_targeting", Types.BOOLEAN));
        compile();
    }
}