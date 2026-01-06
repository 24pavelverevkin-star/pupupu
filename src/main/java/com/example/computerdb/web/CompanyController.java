package com.example.computerdb.web;

import com.example.computerdb.dao.CompanyDao;
import com.example.computerdb.model.Company;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CompanyController {

    @Autowired private CompanyDao dao;

    @GetMapping("/company")
    public String list(Model model) {
        model.addAttribute("companies", dao.findAll());
        return "company";
    }

    @PostMapping("/company/create")
    public String create(@RequestParam("name") String name, @RequestParam("countryId") int countryId) {
        dao.create(name, countryId);
        return "redirect:/company";
    }

    @PostMapping("/company/update")
    public String update(@RequestParam("id") int id, @RequestParam("name") String name, @RequestParam("countryId") int countryId) {
        dao.update(id, name, countryId);
        return "redirect:/company";
    }

    @PostMapping("/company/delete")
    public String delete(@RequestParam("id") int id) {
        dao.delete(id);
        return "redirect:/company";
    }
}