<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Комп'ютери (захищена версія)</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background: #f0f0f0; }
        form { margin: 10px 0; }
    </style>
</head>
<body>
<h1>Комп'ютери (захищена від SQL-Injection)</h1>

<h2>Список комп'ютерів</h2>
<table>
    <tr><th>ID</th><th>Модель</th><th>Ціна</th><th>Компанія ID</th><th>Дії</th></tr>
    <c:forEach var="c" items="${computers}">
        <tr>
            <td>${c.id}</td>
            <td>${c.model}</td>
            <td>${c.price}</td>
            <td>${c.companyId}</td>
            <td>
                <form method="post" action="/computer/update" style="display:inline;">
                    <input type="hidden" name="id" value="${c.id}">
                    <input type="text" name="model" value="${c.model}" required>
                    <input type="number" name="price" value="${c.price}" required>
                    <input type="number" name="companyId" value="${c.companyId}" required>
                    <button type="submit">Оновити</button>
                </form>
                <form method="post" action="/computer/delete" style="display:inline;">
                    <input type="hidden" name="id" value="${c.id}">
                    <button type="submit" onclick="return confirm('Видалити?')">Видалити</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

<h2>Додати комп'ютер</h2>
<form method="post" action="/computer/create">
    <input type="text" name="model" placeholder="Модель" required>
    <input type="number" name="price" placeholder="Ціна" required>
    <input type="number" name="companyId" placeholder="ID компанії" required>
    <button type="submit">Додати</button>
</form>
</body>
</html>