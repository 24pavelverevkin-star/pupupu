package com.example.computerdb.dao;

import com.example.computerdb.model.Country;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public class CountryDao {

    private final JdbcTemplate jdbc;

    public CountryDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public void create(String name) {
        String sql = "INSERT INTO country (name) VALUES (?)";
        jdbc.update(sql, name);
    }

    public List<Country> findAll() {
        String sql = "SELECT id, name FROM country ORDER BY id";
        return jdbc.query(sql, countryRowMapper());
    }

    public void update(int id, String name) {
        String sql = "UPDATE country SET name = ? WHERE id = ?";
        jdbc.update(sql, name, id);
    }

    public void delete(int id) {
        String sql = "DELETE FROM country WHERE id = ?";
        jdbc.update(sql, id);
    }

    private RowMapper<Country> countryRowMapper() {
        return (rs, rowNum) -> new Country(
                rs.getInt("id"),
                rs.getString("name")
        );
    }
}