<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Компанії - Computer DB</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background: #f0f0f0; }
        form { margin: 5px 0; }
        .terminal-section { margin-top: 40px; padding: 20px; border: 2px solid #333; background: #f4f4f4; border-radius: 8px; }
        #sqlInput { width: 100%; font-family: monospace; margin-top: 10px; font-size: 16px; }
        .btn-example { padding: 8px 12px; margin-right: 10px; cursor: pointer; }
        #statusMessage { margin: 15px 0; font-weight: bold; }
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

    <h1>Керування компаніями</h1>

    <h2>Список компаній</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Назва</th>
                <th>ID Країни</th>
                <th>Дії</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${companies}">
                <tr>
                    <td><c:out value="${c.id}"/></td>
                    <td><c:out value="${c.name}"/></td>
                    <td><c:out value="${c.countryId}"/></td>
                    <td>
                        <form method="post" action="/company/delete" style="display:inline;">
                            <input type="hidden" name="id" value="<c:out value='${c.id}'/>">
                            <button type="submit" onclick="return confirm('Видалити?')">Видалити</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="terminal-section">
        <h2>SQL Термінал (Компанії)</h2>
        <div style="margin-bottom: 15px;">
            <button class="btn-example" onclick="setQuery('SELECT * FROM company')">📋 Показати всі</button>
            <button class="btn-example" style="color: green;" onclick="setQuery('INSERT INTO company (name, country_id) VALUES (\'Asus\', 1)')">➕ Додати (INSERT)</button>
            <button class="btn-example" style="color: red;" onclick="setQuery('DELETE FROM company WHERE name = \'Asus\'')">❌ Видалити (DELETE)</button>
        </div>

        <textarea id="sqlInput" rows="4">SELECT * FROM company;</textarea>
        <br>
        <button onclick="runCommand()" style="margin-top: 15px; padding: 12px 30px; background: #222; color: #fff; border: none; cursor: pointer;">
            ▶ ВИКОНАТИ SQL
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
            status.innerText = "Запит виконується...";
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
                    status.innerText = "Знайдено записів: " + data.length;
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