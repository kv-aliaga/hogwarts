<%@ page import="com.hogwarts.model.Boletim" %>
<%@ page import="com.hogwarts.utils.Formatador" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hogwarts.model.banco.Aluno" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 04/02/2026
  Time: 02:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%--Capturando valores do servlet--%>
<%
    List<Boletim> boletins = (List<Boletim>) request.getAttribute("boletins");
    Aluno aluno = (Aluno) request.getAttribute("aluno");
%>

<html>
<head>
    <title>Boletim - <%=aluno.getNome()%></title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
</head>
<body>
<main>
    <h1><%=aluno.getNome()%></h1>
    <h2><%=aluno.getCasaHogwarts().getNome()%></h2>

    <table border="1">
        <thead>
            <tr>
                <th>Professor</th>
                <th>Disciplina</th>
                <th>Nota 1</th>
                <th>Nota 2</th>
                <th>Média</th>
                <th>Observação</th>
                <th>Situação</th>
            </tr>
        </thead>

        <%for (Boletim b : boletins){%>
        <tbody>
            <tr>
                <td><%=b.getProfessor().getNome()%></td>
                <td><%=b.getDisciplina().getNome()%></td>
                <td><%=b.getNota1() == 0 ? "--" : ("<strong>" + b.getNota1() + "</strong>") %></td>
                <td><%=b.getNota2() == 0 ? "--" : ("<strong>" + b.getNota2() + "</strong>") %></td>
                <td><%=b.getMedia() == 0 ? "--" : ("<strong>" + b.getMedia() + "</strong>")%></td>
                <td><%=Formatador.mostrar(b.getObservacao().getObservacao())%></td>
                <td><%=b.getSituacao().getNome()%></td>
            </tr>
        </tbody>
        <%}%>
    </table>
</main>

<script src="<%=request.getContextPath()%>/assets/js/script.js"></script>
</body>
</html>
