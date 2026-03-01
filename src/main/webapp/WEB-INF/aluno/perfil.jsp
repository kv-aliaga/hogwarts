<%@ page import="com.hogwarts.model.banco.Aluno" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 16/02/2026
  Time: 11:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%Aluno aluno = (Aluno) session.getAttribute("aluno");%>

<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/perfil.css">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
</head>
<body>
<form action="aluno-servlet" method="post" id="f">
    <input type="hidden" name="matricula" value="<%=aluno.getMatricula()%>">
</form>

<header>
    <h1>Portal do Aluno - <%=aluno.getCasaHogwarts().getNome()%></h1>
</header>

<main>
    <h3><%=aluno.getNome()%></h3>

    <p>Período:</p>
    <p><strong>Integral</strong></p>

    <p>Turma:</p>
    <p><strong>1ª Série <%=aluno.getCasaHogwarts().getNome()%></strong></p>

    <p>Email:</p>
    <p><strong><%=aluno.getEmail()%></strong></p>

    <p>CPF:</p>
    <p><strong><%=aluno.getCpf()%></strong></p>
</main>
</body>
</html>
