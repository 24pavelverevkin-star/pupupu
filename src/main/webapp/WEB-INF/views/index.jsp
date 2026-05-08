<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>Головна - Computer DB</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; text-align: center; }
        h1 { color: #333; }
        .menu { display: flex; flex-direction: column; gap: 15px; align-items: center; margin-top: 30px; }
        a { text-decoration: none; font-size: 20px; color: white; background-color: #007bff; padding: 10px 20px; border-radius: 5px; width: 200px; }
        a:hover { background-color: #0056b3; }
        .user-panel { position: absolute; top: 20px; right: 40px; padding: 10px; background: #f4f4f4; border-radius: 8px; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <div class="user-panel">
        Ви увійшли як: <b><sec:authentication property="name"/></b>
        <sec:authorize access="hasRole('ADMIN')">
            <span style="color: darkred; font-weight: bold;">(ADMIN)</span>
        </sec:authorize>
        <sec:authorize access="hasRole('USER')">
            <span style="color: green; font-weight: bold;">(USER)</span>
        </sec:authorize>

        <form method="post" action="/logout" style="display:inline; margin-left: 15px;">
            <button type="submit" style="cursor: pointer; padding: 5px 10px;">Вийти</button>
        </form>
    </div>

    <h1>Система управління БД</h1>
    <div class="menu">
        <a href="/country">🌏 Країни</a>
        <a href="/company">🏢 Компанії</a>
        <a href="/computer">💻 Комп'ютери</a>
    </div>
</body>
</html>