package com.example.computerdb.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Computer {
    private int id;
    private String model;
    private double price;
    private int companyId;
}