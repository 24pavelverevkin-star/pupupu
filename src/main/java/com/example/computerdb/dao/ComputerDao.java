package com.example.computerdb.dao;

import com.example.computerdb.model.Computer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ComputerDao {

    private final JdbcTemplate jdbc;

    public ComputerDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public void create(String model, double price, int companyId) {
        String sql = "INSERT INTO computer (model, price, company_id) VALUES (?, ?, ?)";
        jdbc.update(sql, model, price, companyId);
    }

    public List<Computer> findAll() {
        String sql = "SELECT id, model, price, company_id FROM computer ORDER BY id";
        return jdbc.query(sql, computerRowMapper());
    }

    public void update(int id, String model, double price, int companyId) {
        String sql = "UPDATE computer SET model = ?, price = ?, company_id = ? WHERE id = ?";
        jdbc.update(sql, model, price, companyId, id);
    }

    public void delete(int id) {
        String sql = "DELETE FROM computer WHERE id = ?";
        jdbc.update(sql, id);
    }

    private RowMapper<Computer> computerRowMapper() {
        return (rs, rowNum) -> new Computer(
                rs.getInt("id"),
                rs.getString("model"),
                rs.getDouble("price"),
                rs.getInt("company_id")
        );
    }
}