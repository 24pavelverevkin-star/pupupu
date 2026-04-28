package com.example.computerdb.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/sql")
public class SqlTerminalController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/execute")
    public Object executeQuery(@RequestParam String query, Authentication authentication) {
        try {
            String cleanQuery = query.trim();
            boolean isSelect = cleanQuery.toUpperCase().startsWith("SELECT");

            // Перевірка, чи має користувач права адміністратора
            boolean isAdmin = authentication != null &&
                    authentication.getAuthorities().contains(new SimpleGrantedAuthority("ROLE_ADMIN"));

            if (!isSelect && !isAdmin) {
                return Map.of("error", "ПОМИЛКА ДОСТУПУ: Тільки адміністратор може змінювати дані!");
            }

            if (isSelect) {
                return jdbcTemplate.queryForList(cleanQuery);
            } else {
                int rows = jdbcTemplate.update(cleanQuery);
                return Map.of("message", "Успішно! Змінено рядків: " + rows);
            }
        } catch (Exception e) {
            return Map.of("error", e.getMessage());
        }
    }
}