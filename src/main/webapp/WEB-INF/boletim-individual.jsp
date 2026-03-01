<%@ page import="com.hogwarts.model.Boletim" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hogwarts.utils.Formatador" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 04/02/2026
  Time: 02:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--Capturando valores do servlet--%>
<%
    List<Boletim> boletim = (List<Boletim>) request.getAttribute("boletim");
%>

<html>
<head>
    <link rel="stylesheet" href="css/boletim.css">
</head>
<body>
    <main>
        <header>
            <h1><%=boletim.get(0).getAluno().getNome()%></h1>
            <h2><%=boletim.get(0).getCasaHogwarts().getNome()%></h2>
        </header>

        <table class="boletim-table">
            <thead>
                <tr>
                    <th>Disciplina / Prof.</th>
                    <th>Nota 1</th>
                    <th>Nota 2</th>
                    <th>Média</th>
                    <th>Situação</th>
                </tr>
            </thead>
            <tbody>
                <%for (Boletim b: boletim) { 
                    String statusClass = b.getSituacao().equalsIgnoreCase("Aprovado") ? "aprovado" : "reprovado";
                %>
                <tr>
                    <td>
                        <strong><%=b.getDisciplina().getNome()%></strong><br>
                        <small>Prof: <%=b.getProfessor().getNome()%></small>
                    </td>
                    <td><%=b.getNota1()%></td>
                    <td><%=b.getNota2()%></td>
                    <td><strong><%=b.getMedia()%></strong></td>
                    <td>
                        <span class="situacao <%=statusClass%>"><%=b.getSituacao()%></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="5" class="observacao">
                        Obs: <%=Formatador.mostrar(b.getObservacao().getObservacao())%>
                    </td>
                </tr>
                <%}%>
            </tbody>
        </table>
    </main>
</body>
</html>