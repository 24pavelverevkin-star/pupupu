<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Країни (захищена версія)</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background: #f0f0f0; }
        form { margin: 10px 0; }
    </style>
</head>
<body>
<h1>Країни (захищена від SQL-Injection)</h1>

<h2>Список країн</h2>
<table>
    <tr><th>ID</th><th>Назва</th><th>Дії</th></tr>
    <c:forEach var="c" items="${countries}">
        <tr>
            <td>${c.id}</td>
            <td>${c.name}</td>
            <td>
                <form method="post" action="/country/update" style="display:inline;">
                    <input type="hidden" name="id" value="${c.id}">
                    <input type="text" name="name" value="${c.name}" required>
                    <button type="submit">Оновити</button>
                </form>
                <form method="post" action="/country/delete" style="display:inline;">
                    <input type="hidden" name="id" value="${c.id}">
                    <button type="submit" onclick="return confirm('Видалити?')">Видалити</button>
                </form>
            </td>
        </tr>
    </c:forEach>
</table>

<h2>Додати країну</h2>
<form method="post" action="/country/create">
    <input type="text" name="name" placeholder="Назва країни" required>
    <button type="submit">Додати</button>
</form>
</body>
</html>