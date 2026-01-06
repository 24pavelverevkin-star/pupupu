<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Компанії (захищена версія)</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background: #f0f0f0; }
        form { margin: 10px 0; }
    </style>
</head>
<body>
<div style="margin-bottom: 20px;">
    <a href="/" style="text-decoration: none; font-size: 16px; color: #007bff;">⬅ На головну</a>
    <span style="margin: 0 10px;">|</span>
    <a href="/country">Країни</a> |
    <a href="/company">Компанії</a> |
    <a href="/computer">Комп'ютери</a>
</div>
<hr>
<h1>Компанії (захищена від SQL-Injection)</h1>

<h2>Список компаній</h2>
<table>
    <tr><th>ID</th><th>Назва</th><th>Країна ID</th><th>Дії</th></tr>
    <c:forEach var="c" items="${companies}">
        <tr>
            <td>${c.id}</td>
            <td>${c.name}</td>
            <td>${c.countryId}</td>
            <td>
                <form method="post" action="/company/update" style="display:inline;">
                    <input type="hidden" name="id" value="${c.id}">
                    <input type="text" name="name" value="${c.name}" required>
                    <input type="number" name="countryId" value="${c.countryId}" required>
                    <button type="submit">Оновити</button>
                </form>
                <form method="post" action="/company/delete" style="display:inline;">
                    <input type="hidden" name="id" value="${c.id}">
                    <button type="submit" onclick="return confirm('Видалити?')">Видалити</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

<h2>Додати компанію</h2>
<form method="post" action="/company/create">
    <input type="text" name="name" placeholder="Назва компанії" required>
    <input type="number" name="countryId" placeholder="ID країни" required>
    <button type="submit">Додати</button>
</form>
</body>
</html>