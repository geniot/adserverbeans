package com.adserversoft.flexfuse.server.api.dao;

import com.adserversoft.flexfuse.server.api.Language;

import java.util.List;

public interface ILanguageDAO {
    public List<Language> getLanguages() throws Exception;

    void updateCSV() throws Exception;
}