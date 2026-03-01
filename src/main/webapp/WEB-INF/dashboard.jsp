<%@ page import="java.util.HashMap" %>
<%@ page import="com.hogwarts.model.QuadroObservacoes" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hogwarts.model.Dashboard" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.DecimalFormat" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 03/02/2026
  Time: 23:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--Capturando valores do servlet--%>
<%
    Dashboard dash = (Dashboard) request.getAttribute("dashboard");
    DecimalFormat df = new DecimalFormat("0.00");
%>

<main>
    <div class="card">
        <h1>RANKING</h1>
        <% int i = 0;
        for (Map.Entry<String, Double> entrada : dash.getRanking().entrySet()){
            i++; %>
            <div class="ranking-item">
                <span><strong><%=i%>º</strong> <%=entrada.getKey()%></span>
                <strong><%=entrada.getValue()%></strong>
            </div>
        <% } %>
    </div>

    <div class="card card-dark">
        <h1>ALUNOS ATIVOS</h1>
        <p class="big-number"><%=dash.getQtdAlunos()%></p>
    </div>

    <div class="card card-light">
        <h1>MÉDIA DAS CASAS</h1>
        <% for (Map.Entry<String, Double> entrada : dash.getMediaCasas().entrySet()){ %>
            <div class="casa-item">
                <span><%=entrada.getKey()%></span>
                <strong><%=df.format(entrada.getValue())%></strong>
            </div>
        <% } %>
    </div>

    <div style="grid-column: 1 / -1;">
        <h1>QUADRO DE OBSERVAÇÕES</h1>
        <% for (QuadroObservacoes entrada : dash.getQuadroObservacoes()){ %>
            <div class="obs-container">
                <div class="obs-item">
                    <em>"<%=entrada.getObservacao()%>"</em>
                    <div class="obs-info">
                        <h3><%=entrada.getAluno()%> (<%=entrada.getCasa()%>)</h3>
                        <strong>Prof. <%=entrada.getProfessor()%></strong>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
</main>