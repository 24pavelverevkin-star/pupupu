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
        .terminal-section { margin-top: 40px; padding: 20px; border: 2px solid #000; background: #eef2f3; }
        #sqlInput { width: 100%; font-family: monospace; margin-top: 10px; }
        #statusMessage { margin: 10px 0; font-weight: bold; }
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

    <h2>Список техніки</h2>
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
                    <td>${c.id}</td>
                    <td>${c.model}</td>
                    <td>${c.price}</td>
                    <td>${c.companyId}</td>
                    <td>
                        <form method="post" action="/computer/delete" style="display:inline;">
                            <input type="hidden" name="id" value="${c.id}">
                            <button type="submit">Видалити</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="terminal-section">
        <h2>SQL Термінал (Комп'ютери)</h2>
        <div style="margin-bottom: 10px;">
            <button onclick="setQuery('SELECT * FROM computer')">📋 Всі записи</button>
            <button style="color: darkgreen;" onclick="setQuery('INSERT INTO computer (model, price, company_id) VALUES (\'MacBook Air\', 1200.00, 1)')">➕ Додати (INSERT)</button>
            <button style="color: darkred;" onclick="setQuery('DELETE FROM computer WHERE model = \'MacBook Air\'')">❌ Видалити (DELETE)</button>
        </div>

        <textarea id="sqlInput" rows="4">SELECT * FROM computer;</textarea>
        <br>
        <button onclick="runCommand()" style="margin-top: 10px; padding: 10px 20px; background: #333; color: #fff; cursor: pointer;">
            ▶ ВИКОНАТИ КОМАНДУ
        </button>

        <div id="statusMessage"></div>
        <div id="queryResult"></div>
    </div>

    <script>
        function setQuery(q) { document.getElementById('sqlInput').value = q + ";"; }

        async function runCommand() {
            const query = document.getElementById('sqlInput').value;
            const status = document.getElementById('statusMessage');
            const resultDiv = document.getElementById('queryResult');
            status.innerText = "Обробка...";
            resultDiv.innerHTML = "";

            try {
                const response = await fetch('/api/sql/execute?query=' + encodeURIComponent(query), { method: 'POST' });
                const data = await response.json();

                if (data.error) {
                    status.style.color = "red";
                    status.innerText = "Помилка: " + data.error;
                } else if (data.message) {
                    status.style.color = "green";
                    status.innerText = data.message;
                    setTimeout(function() { location.reload(); }, 1500);
                } else {
                    status.style.color = "green";
                    status.innerText = "Знайдено: " + data.length;
                    renderTable(data);
                }
            } catch (err) { status.innerText = "Помилка мережі"; }
        }

        function renderTable(data) {
            const resultDiv = document.getElementById('queryResult');
            if (!data || data.length === 0) return;
            let html = "<table border='1'><thead><tr>";
            const headers = Object.keys(data[0]);
            for (var i = 0; i < headers.length; i++) { html += "<th>" + headers[i].toUpperCase() + "</th>"; }
            html += "</tr></thead><tbody>";
            for (var j = 0; j < data.length; j++) {
                html += "<tr>";
                for (var k = 0; k < headers.length; k++) {
                    var val = data[j][headers[k]];
                    html += "<td>" + (val !== null ? val : "") + "</td>";
                }
                html += "</tr>";
            }
            resultDiv.innerHTML = html + "</tbody></table>";
        }
    </script>
</body>
</html>