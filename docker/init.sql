-- Таблиця: країна
CREATE TABLE IF NOT EXISTS country (
    id   SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Таблиця: фірма
CREATE TABLE IF NOT EXISTS company (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    country_id INTEGER NOT NULL REFERENCES country(id) ON DELETE CASCADE
);

-- Таблиця: комп’ютер
CREATE TABLE IF NOT EXISTS computer (
    id          SERIAL PRIMARY KEY,
    model       VARCHAR(150) NOT NULL,
    company_id  INTEGER NOT NULL REFERENCES company(id) ON DELETE CASCADE,
    price       NUMERIC(12,2) NOT NULL
);

-- Тестові дані (для демо)
INSERT INTO country (name) VALUES ('Китай'), ('США'), ('Німеччина')
ON CONFLICT (name) DO NOTHING;

INSERT INTO company (name, country_id) VALUES 
('Apple', 2), ('Lenovo', 1), ('Dell', 2)
ON CONFLICT DO NOTHING;

INSERT INTO computer (model, company_id, price) VALUES 
('MacBook Pro', 1, 2500.00),
('ThinkPad X1', 2, 1800.00),
('XPS 13', 3, 2200.00)
ON CONFLICT DO NOTHING;
CREATE TABLE IF NOT EXISTS users (
                                     username VARCHAR(50) PRIMARY KEY,
    password VARCHAR(100) NOT NULL,
    enabled BOOLEAN NOT NULL,
    role VARCHAR(50) NOT NULL
    );

INSERT INTO users (username, password, enabled, role) VALUES
                                                          ('admin', 'admin123', true, 'ROLE_ADMIN'),
                                                          ('user', 'user123', true, 'ROLE_USER')
    ON CONFLICT DO NOTHING;