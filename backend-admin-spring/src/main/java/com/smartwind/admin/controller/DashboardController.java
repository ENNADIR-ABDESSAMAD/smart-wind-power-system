package com.smartwind.admin.controller;

import com.smartwind.admin.repository.SensorReadingRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardController {

    private final SensorReadingRepository repository;

    public DashboardController(SensorReadingRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/")
    public String dashboard(Model model) {
        var readings = repository.findAllByOrderByRecordedAtDesc(PageRequest.of(0, 50));
        model.addAttribute("readings", readings.getContent());
        model.addAttribute("totalCount", readings.getTotalElements());
        return "dashboard";
    }
}
