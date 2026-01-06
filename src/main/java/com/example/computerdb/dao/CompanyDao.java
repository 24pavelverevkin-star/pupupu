package com.example.computerdb.dao;

import com.example.computerdb.model.Company;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CompanyDao {

    private final JdbcTemplate jdbc;

    public CompanyDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public void create(String name, int countryId) {
        String sql = "INSERT INTO company (name, country_id) VALUES (?, ?)";
        jdbc.update(sql, name, countryId);
    }

    public List<Company> findAll() {
        String sql = "SELECT id, name, country_id FROM company ORDER BY id";
        return jdbc.query(sql, companyRowMapper());
    }

    public void update(int id, String name, int countryId) {
        String sql = "UPDATE company SET name = ?, country_id = ? WHERE id = ?";
        jdbc.update(sql, name, countryId, id);
    }

    public void delete(int id) {
        String sql = "DELETE FROM company WHERE id = ?";
        jdbc.update(sql, id);
    }

    private RowMapper<Company> companyRowMapper() {
        return (rs, rowNum) -> new Company(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getInt("country_id")
        );
    }
}