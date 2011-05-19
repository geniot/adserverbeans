package com.adserversoft.flexfuse.server.adserver;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdTagServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String AdPlaceId = request.getParameter("id");
        response.getWriter().println("<img src=\"http://www.svatovo.lg.ua/forum/images/smiles/icon_smile.gif\" title=\""+AdPlaceId+"\">");
    }
}
