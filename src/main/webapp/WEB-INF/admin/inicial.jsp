<%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 07/02/2026
  Time: 19:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String nomeAdmin = (String) session.getAttribute("nomeAdmin");
    if (nomeAdmin == null) nomeAdmin = "Jones";
%>

<html>
<head>
    <title>Painel do Administrador</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/iniciais/inicial-adm.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
</head>
<body>
<main>
    <h1>Ola, <%=nomeAdmin%>. Bem-vindo!</h1>
    <p>O que você quer fazer hoje?</p>

    <form action="admin-servlet" id="f" method="get"></form>

    <form action="dashboard-servlet" method="get">
        <button type="submit" class="acao-painel">Dashboards</button>
    </form>

    <section>
        <h3>Casas de Hogwarts</h3>
        <button type="submit" form="f" name="tipo" value="casas">Gerenciar casas</button>
    </section>

    <section>
        <h3>Disciplinas e Professores</h3>
        <button type="submit" form="f" name="tipo" value="disciplinas">Gerenciar disciplinas e professores</button>
    </section>

    <section>
        <h3>Alunos</h3>
        <button type="submit" form="f" name="tipo" value="alunos">Gerenciar alunos</button>
    </section>
</main>
</body>
</html>