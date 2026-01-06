package com.example.computerdb.web;

import com.example.computerdb.dao.ComputerDao;
import com.example.computerdb.model.Computer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ComputerController {

    @Autowired private ComputerDao dao;

    @GetMapping("/computer")
    public String list(Model model) {
        model.addAttribute("computers", dao.findAll());
        return "computer";
    }

    @PostMapping("/computer/create")
    public String create(@RequestParam("model") String model, @RequestParam("price") double price, @RequestParam("companyId") int companyId) {
        dao.create(model, price, companyId);
        return "redirect:/computer";
    }

    @PostMapping("/computer/update")
    public String update(@RequestParam("id") int id, @RequestParam("model") String model, @RequestParam("price") double price, @RequestParam("companyId") int companyId) {
        dao.update(id, model, price, companyId);
        return "redirect:/computer";
    }

    @PostMapping("/computer/delete")
    public String delete(@RequestParam("id") int id) {
        dao.delete(id);
        return "redirect:/computer";
    }
}