<%@ page import="com.hogwarts.utils.Formatador" %>
<%@ page import="com.hogwarts.model.banco.Aluno" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 10/02/2026
  Time: 01:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%
    List<Aluno> alunos = (List<Aluno>) session.getAttribute("alunos");
    String nomeProf = (String) session.getAttribute("nomeProf");
    String disciplina = (String) session.getAttribute("disciplina");
    List<String> disciplinaList = (List<String>) session.getAttribute("disciplinaList");

    if (nomeProf == null) nomeProf = "Jones";
%>

<html>
<head>
    <title>Área Inicial - Professor</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/inicial-prof.css">
</head>
<body>
<main>
    <form action="professor-servlet" id="f" method="get"></form>
    
    <h1>Olá, <%=nomeProf%>. Bem-vindo!</h1>
    <h2>Professor de <%=Formatador.mostrar(disciplina)%></h2>
    <p>É professor de outra disciplina?</p>
    <div class="modal">
        <button type="button" name="tipo" class="abre-modal astext" data-modal="modal-1">
            Clique aqui para ver suas disciplinas
        </button>

        <dialog id="modal-1">
            <button type="button" class="fecha-modal" data-modal="modal-1">x</button>

            <%if (disciplinaList.isEmpty()){%>
            <p><strong>Você não tem nenhuma disciplina vigente.</strong></p>
            <%} else if (disciplinaList.size() == 1){%>
            <p><strong>Sua única disciplina vigente é <%=disciplina%></strong></p>

            <%} else {%>
            <p>Você tem as seguintes disciplinas:</p>
            <p>Clique nelas para ser redirecionado para as páginas</p>

            <form action="professor-servlet" method="get">

                <input type="hidden" name="nome" value="<%=nomeProf%>">

                <%for (String d : disciplinaList){%>
                <input type="submit" name="disciplina" value="<%=d%>">
                <%}%>
            </form>
            <%}%>
        </dialog>
    </div>
    <p>O que você quer fazer hoje?</p>

    <form action="dashboard-servlet" method="get">
        <input type="submit" value="Clique aqui para ver dashboards" >
    </form>

    <form method="get" action="boletim-servlet">
        <button type="submit" name="tipo" value="todos">Boletim de todos os alunos</button>
        <button type="submit" name="tipo" value="observacao">Cadastrar observação</button>

        <input type="hidden" name="disciplina" value="<%=disciplina%>">
    </form>

    <div class="modal">
        <button type="button" name="tipo" class="abre-modal" data-modal="modal-2">
            Boletim individual
        </button>

        <dialog id="modal-2">
            <button type="button" class="fecha-modal" data-modal="modal-2">
                <img src="<%=request.getContextPath()%>/assets/icons/fecha.webp" alt="Sair">
            </button>

            <form action="boletim-servlet" method="get">
                <div>
                    <p>Escolha uma forma de seleção</p>

                    <label>
                        <input type="radio" name="modo" id="digitar" value="digitar" checked>
                        Digite a matrícula
                    </label>

                    <label>
                        <input type="radio" name="modo" id="escolher" value="escolher">
                        Escolha o aluno
                    </label>

                </div>

                <section id="digitar-section">
                    <label for="matricula-digitar">Digite a matrícula do aluno:</label>
                    <input type="number" name="matricula" id="matricula-digitar" autocomplete="on" min="10000" required>
                </section>

                <section id="escolher-section" style="display: none;">
                    <label for="matricula-select">Selecione o aluno:</label>
                    <select name="matricula" id="matricula-select" required disabled>
                        <option value="">Selecione</option>
                        <%for (Aluno a : alunos){%>
                        <option value="<%=a.getMatricula()%>"><%=a.getNome()%> - <%=a.getMatricula()%></option>
                        <%}%>
                    </select>
                </section>

                <input type="hidden" name="disciplina" value="<%=disciplina%>">

                <button type="submit" name="tipo" value="individual">Enviar dados</button>
            </form>
        </dialog>
    </div>
</main>
<script src="<%=request.getContextPath()%>/assets/js/script.js" defer></script>

</body>
</html>
