<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Комп'ютери - Computer DB</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background: #f0f0f0; }
        form { margin: 5px 0; }
        /* Стилі терміналу */
        .terminal-section { margin-top: 40px; padding: 20px; border: 2px solid #333; background: #f4f4f4; border-radius: 8px; }
        #sqlInput { width: 100%; font-family: 'Courier New', monospace; margin-top: 10px; font-size: 16px; padding: 10px; box-sizing: border-box; }
        .btn-example { padding: 8px 12px; margin-right: 10px; cursor: pointer; background: #e0e0e0; border: 1px solid #999; border-radius: 4px; }
        .btn-example:hover { background: #d0d0d0; }
        #statusMessage { margin: 15px 0; font-weight: bold; }
        #queryResult table { background: white; width: 100%; }
    </style>
</head>
<body>

    <div style="margin-bottom: 20px;">
        <a href="/" style="text-decoration: none; color: #007bff;">⬅ На головну</a>
        <span style="margin: 0 10px;">|</span>
        <a href="/country">Країни</a> |
        <a href="/company">Компанії</a> |
        <a href="/computer">Комп'ютери</a>
    </div>
    <hr>

    <h1>Керування комп'ютерами</h1>

    <h2>Список комп'ютерів у базі</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Модель</th>
                <th>Ціна</th>
                <th>ID Компанії</th>
                <th>Дії</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${computers}">
                <tr>
                    <td><c:out value="${c.id}"/></td>
                    <td><c:out value="${c.model}"/></td>
                    <td><c:out value="${c.price}"/></td>
                    <td><c:out value="${c.companyId}"/></td>
                    <td>
                        <form method="post" action="/computer/delete" style="display:inline;">
                            <input type="hidden" name="id" value="<c:out value='${c.id}'/>">
                            <button type="submit" onclick="return confirm('Видалити?')">Видалити</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="terminal-section">
        <h2>SQL Термінал</h2>
        <p>Виберіть приклад команди або введіть свій запит вручну:</p>

        <div style="margin-bottom: 15px;">
            <button class="btn-example" onclick="setQuery('SELECT * FROM computer')">📋 Показати всі</button>

            <button class="btn-example" style="color: #2e7d32;"
                    onclick="setQuery('INSERT INTO computer (model, price, company_id) VALUES (\'MacBook Air\', 1200.00, 1)')">
                ➕ Приклад: Додати (INSERT)
            </button>

            <button class="btn-example" style="color: #0056b3;"
                    onclick="setQuery('UPDATE computer SET model = \'MacBook Pro M3\' WHERE id = 1')">
                📝 Приклад: Оновити (UPDATE)
            </button>

            <button class="btn-example" style="color: #c62828;"
                    onclick="setQuery('DELETE FROM computer WHERE model = \'MacBook Air\'')">
                ❌ Приклад: Видалити (DELETE)
            </button>
        </div>

        <textarea id="sqlInput" rows="4">SELECT * FROM computer;</textarea>
        <br>
        <button onclick="runCommand()" style="margin-top: 15px; padding: 12px 30px; background: #222; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
            ▶ ВИКОНАТИ SQL КОМАНДУ
        </button>

        <div id="statusMessage"></div>
        <div id="queryResult"></div>
    </div>

    <script>
        function setQuery(q) {
            document.getElementById('sqlInput').value = q + ";";
        }

        async function runCommand() {
            const query = document.getElementById('sqlInput').value;
            const status = document.getElementById('statusMessage');
            const resultDiv = document.getElementById('queryResult');

            status.innerText = "Запит виконується...";
            status.style.color = "blue";
            resultDiv.innerHTML = "";

            try {
                const response = await fetch('/api/sql/execute?query=' + encodeURIComponent(query), {
                    method: 'POST'
                });

                const data = await response.json();

                if (data.error) {
                    status.style.color = "red";
                    status.innerText = "Помилка: " + data.error;
                } else if (data.message) {
                    status.style.color = "green";
                    status.innerText = data.message;
                    // Автоматичне оновлення основної таблиці через 1.5 сек
                    setTimeout(function() { location.reload(); }, 1500);
                } else {
                    status.style.color = "green";
                    status.innerText = "Знайдено записів: " + data.length;
                    renderTable(data);
                }
            } catch (err) {
                status.style.color = "red";
                status.innerText = "Помилка мережі або сервера";
            }
        }

        function renderTable(data) {
            const resultDiv = document.getElementById('queryResult');
            if (!data || data.length === 0) {
                resultDiv.innerHTML = "<p>Результат порожній.</p>";
                return;
            }

            let html = "<table border='1'><thead><tr style='background: #eee;'>";
            const headers = Object.keys(data[0]);

            for (var i = 0; i < headers.length; i++) {
                html += "<th>" + headers[i].toUpperCase() + "</th>";
            }
            html += "</tr></thead><tbody>";

            for (var j = 0; j < data.length; j++) {
                html += "<tr>";
                for (var k = 0; k < headers.length; k++) {
                    var cellValue = data[j][headers[k]];
                    html += "<td>" + (cellValue !== null ? cellValue : "") + "</td>";
                }
                html += "</tr>";
            }

            html += "</tbody></table>";
            resultDiv.innerHTML = html;
        }
    </script>
</body>
</html>