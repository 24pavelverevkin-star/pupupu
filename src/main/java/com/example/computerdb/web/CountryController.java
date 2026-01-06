package com.example.computerdb.web;

import com.example.computerdb.dao.CountryDao;
import com.example.computerdb.model.Country;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CountryController {

    @Autowired private CountryDao dao;

    @GetMapping("/country")
    public String list(Model model) {
        model.addAttribute("countries", dao.findAll());
        return "country";
    }

    @PostMapping("/country/create")
    public String create(@RequestParam("name") String name) {
        dao.create(name);
        return "redirect:/country";
    }

    @PostMapping("/country/update")
    public String update(@RequestParam("id") int id, @RequestParam("name") String name) {
        dao.update(id, name);
        return "redirect:/country";
    }

    @PostMapping("/country/delete")
    public String delete(@RequestParam("id") int id) {
        dao.delete(id);
        return "redirect:/country";
    }
}