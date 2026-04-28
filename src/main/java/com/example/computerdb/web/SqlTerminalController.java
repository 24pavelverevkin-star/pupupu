package com.example.computerdb.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/sql")
public class SqlTerminalController {

    @Autowired
    private JdbcTemplate jdbcTemplate;//текст

    @PostMapping("/execute")
    public Object executeQuery(@RequestParam String query) {
        try {
            String cleanQuery = query.trim();
            // читання
            if (cleanQuery.toUpperCase().startsWith("SELECT")) {
                return jdbcTemplate.queryForList(cleanQuery);
            } else {
                // рядки
                int rows = jdbcTemplate.update(cleanQuery);
                return Map.of("message", "Успішно! Змінено рядків: " + rows);
            }
        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}