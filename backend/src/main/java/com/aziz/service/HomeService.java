package com.aziz.service;

import com.aziz.modal.Home;
import com.aziz.modal.HomeCategory;

import java.util.List;

public interface HomeService {

    public Home createHomePageData(List<HomeCategory> allCategories);
}
