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
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/execute")
    public Object executeQuery(@RequestParam String query) {
        try {
            String cleanQuery = query.trim();
            // Якщо запит починається з SELECT, повертаємо список рядків
            if (cleanQuery.toUpperCase().startsWith("SELECT")) {
                return jdbcTemplate.queryForList(cleanQuery);
            } else {
                // Для INSERT/UPDATE/DELETE повертаємо кількість змінених рядків
                int rows = jdbcTemplate.update(cleanQuery);
                return Map.of("message", "Успішно! Змінено рядків: " + rows);
            }
        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}