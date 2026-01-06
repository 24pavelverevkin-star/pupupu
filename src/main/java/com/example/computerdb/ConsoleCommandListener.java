package com.example.computerdb;

import com.example.computerdb.dao.CompanyDao;
import com.example.computerdb.dao.ComputerDao;
import com.example.computerdb.dao.CountryDao;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component // Робимо це звичайним компонентом Spring
public class ConsoleCommandListener implements CommandLineRunner {

    private final CompanyDao companyDao;
    private final CountryDao countryDao;
    private final ComputerDao computerDao;

    public ConsoleCommandListener(CompanyDao companyDao, CountryDao countryDao, ComputerDao computerDao) {
        this.companyDao = companyDao;
        this.countryDao = countryDao;
        this.computerDao = computerDao;
    }

    @Override
    public void run(String... args) {
        // ЗАПУСКАЄМО СКАНЕР В ОКРЕМОМУ ПОТОЦІ (Thread)
        // Це критично важливо: інакше Scanner заблокує запуск веб-сайту!
        Thread consoleThread = new Thread(() -> {
            Scanner scanner = new Scanner(System.in);
            System.out.println("\n----------------------------------------------------------");
            System.out.println(" СЕРВЕР ЗАПУЩЕНО! Веб-сайт працює.");
            System.out.println(" Ви можете вводити команди (insert/update...) прямо тут.");
            System.out.println("----------------------------------------------------------\n");

            while (true) {
                // Чекаємо введення, не навантажуючи процесор
                if (scanner.hasNextLine()) {
                    String input = scanner.nextLine().trim();
                    if ("exit".equalsIgnoreCase(input)) {
                        System.out.println("Робота консолі завершена (сервер продовжує працювати).");
                        break;
                    }
                    try {
                        executeCommand(input);
                    } catch (Exception e) {
                        System.out.println("Помилка: " + e.getMessage());
                    }
                    System.out.print("> "); // Запрошення до наступної команди
                }
            }
        });

        // Встановлюємо ім'я потоку для зручності налагодження
        consoleThread.setName("Console-Input-Thread");
        // Запускаємо
        consoleThread.start();
    }

    // --- Далі йде твоя логіка парсингу без змін ---

    private void executeCommand(String cmd) {
        cmd = cmd.replaceAll("\\s+", " ").trim();
        if (cmd.isEmpty()) return;

        if (!cmd.endsWith(";")) {
            System.out.println("Команда повинна закінчуватися ';'");
            return;
        }
        cmd = cmd.substring(0, cmd.length() - 1).trim();

        String[] parts = cmd.split("\\s+", 3);
        if (parts.length < 3) {
            // Для команд read (які можуть не мати параметрів) потрібна окрема перевірка,
            // але за твоєю логікою read теж має 2 слова, тому залишимо як є,
            // але краще перевірити довжину для read окремо.
            if(parts.length == 2 && parts[0].equalsIgnoreCase("read")) {
                // Дозволимо read без параметрів, якщо логіка це підтримує
            } else {
                System.out.println("Невірний формат команди");
                return;
            }
        }

        String operation = parts[0].toLowerCase();
        String table = parts[1].toLowerCase();
        // Якщо параметрів немає (наприклад для read), беремо пустий рядок
        String params = parts.length > 2 ? parts[2] : "";

        switch (operation + " " + table) {
            case "insert company" -> parseInsertCompany(params);
            case "update company" -> parseUpdateCompany(params);
            case "delete company" -> parseDeleteCompany(params);
            case "read company" -> companyDao.findAll().forEach(System.out::println);

            case "insert country" -> parseInsertCountry(params);
            case "update country" -> parseUpdateCountry(params);
            case "delete country" -> parseDeleteCountry(params);
            case "read country" -> countryDao.findAll().forEach(System.out::println);

            case "insert computer" -> parseInsertComputer(params);
            case "update computer" -> parseUpdateComputer(params);
            case "delete computer" -> parseDeleteComputer(params);
            case "read computer" -> computerDao.findAll().forEach(System.out::println);

            default -> System.out.println("Невідома команда або таблиця");
        }
    }

    // ===== COMPANY =====
    private void parseInsertCompany(String params) {
        try {
            String name = extractValue(params, "name");
            int countryId = extractInt(params, "country_id");
            companyDao.create(name, countryId);
            System.out.println("Компанія додана");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    private void parseUpdateCompany(String params) {
        try {
            int id = extractInt(params, "id");
            String name = extractValue(params, "name");
            int countryId = extractInt(params, "country_id");
            companyDao.update(id, name, countryId);
            System.out.println("Компанія оновлена");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    private void parseDeleteCompany(String params) {
        try {
            int id = extractInt(params, "id");
            companyDao.delete(id);
            System.out.println("Компанія видалена");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    // ===== COUNTRY =====
    private void parseInsertCountry(String params) {
        try {
            String name = extractValue(params, "name");
            countryDao.create(name);
            System.out.println("Країна додана");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    private void parseUpdateCountry(String params) {
        try {
            int id = extractInt(params, "id");
            String name = extractValue(params, "name");
            countryDao.update(id, name);
            System.out.println("Країна оновлена");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    private void parseDeleteCountry(String params) {
        try {
            int id = extractInt(params, "id");
            countryDao.delete(id);
            System.out.println("Країна видалена");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    // ===== COMPUTER =====
    private void parseInsertComputer(String params) {
        try {
            String model = extractValue(params, "model");
            double price = extractDouble(params, "price");
            int companyId = extractInt(params, "company_id");
            computerDao.create(model, price, companyId);
            System.out.println("Комп'ютер доданий");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    private void parseUpdateComputer(String params) {
        try {
            int id = extractInt(params, "id");
            String model = extractValue(params, "model");
            double price = extractDouble(params, "price");
            int companyId = extractInt(params, "company_id");
            computerDao.update(id, model, price, companyId);
            System.out.println("Комп'ютер оновлений");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    private void parseDeleteComputer(String params) {
        try {
            int id = extractInt(params, "id");
            computerDao.delete(id);
            System.out.println("Комп'ютер видалений");
        } catch (Exception e) { System.out.println("Fail: " + e.getMessage()); }
    }

    // Допоміжні методи
    private String extractValue(String params, String key) {
        String pattern = key + "='([^']*)'";
        Matcher m = Pattern.compile(pattern).matcher(params);
        if (m.find()) return m.group(1);
        throw new IllegalArgumentException("Параметр '" + key + "' не знайдено");
    }

    private int extractInt(String params, String key) {
        return Integer.parseInt(extractValue(params, key));
    }

    private double extractDouble(String params, String key) {
        return Double.parseDouble(extractValue(params, key));
    }
}