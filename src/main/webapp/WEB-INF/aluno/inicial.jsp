<%@ page import="com.hogwarts.model.banco.Aluno" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Aluno aluno = (Aluno) session.getAttribute("aluno");

    if (aluno == null) {
        response.sendRedirect("login.html");
        return;
    }

    String casaHogwartsNome = aluno.getCasaHogwarts().getNome();
    String nomeCss;

    switch (casaHogwartsNome.toLowerCase()) {
        case "grifinória":
            nomeCss = "grifinoria.css";
            break;
        case "sonserina":
            nomeCss = "sonserina.css";
            break;
        case "lufa-lufa":
            nomeCss = "lufa-lufa.css";
            break;
        default:
            nomeCss = "corvinal.css";
            break;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <title>Portal do Aluno - <%= aluno.getCasaHogwarts().getNome() %></title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,400;0,600;1,400&display=swap"
          rel="stylesheet">
    <link href="https://fonts.googleapis.com/2?family=Harry+P&display=swap"
          rel="stylesheet">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">

    <link rel="stylesheet" type="text/css" href="assets/css/casas/<%= nomeCss %>">

</head>

<body>
<form action="aluno-servlet" method="post" id="f">
    <input type="hidden" name="matricula" value="<%=aluno.getMatricula()%>">
</form>

<form action="download-servlet" method="post" id="d">
    <input type="hidden" name="matricula" value="<%=aluno.getMatricula()%>">
</form>

<header class="hero">
    <div class="overlay"></div>

    <div class="top-title">
        <span class="line"></span>

        <h1>Portal do Aluno - <%=aluno.getCasaHogwarts().getNome()%>
        </h1>
        <span class="line"></span>
    </div>

    <div class="hero-content">

        <h2>Olá, <%=aluno.getNome()%>!<br>Seja muito bem-vindo(a).</h2>

        <p>
            “Enquanto este castelo se mantiver erguido, manter-se-á também o compromisso
            solene de instruir, proteger e iluminar todos aqueles que escolhem trilhar
            o caminho do saber.”
        </p>
    </div>
</header>

<section class="cards">
    <div class="card">

        <img src="assets/images/pags-alunos/card-observacao.png" alt="Notas e Observações">
        <h3>Visualizar notas e observações</h3>
        <p>Seção reservada para visualização de notas e observações.</p>

        <button form="f" name="acao" value="boletim">Acessar</button>
    </div>

    <div class="card">

        <img src="assets/images/pags-alunos/card-boletim.png" alt="Emitir Boletim Escolar">
        <h3>Emitir Boletim Escolar</h3>
        <p>Seção reservada para a emissão do boletim escolar - sujeito a não disponibilidade de notas*.</p>

        <button form="d" name="acao" value="download">Acessar</button>
    </div>

    <div class="card">

        <img src="assets/images/pags-alunos/card-perfil.png" alt="Visualizar Perfil">
        <h3>Visualizar perfil</h3>
        <p>Seção reservada para visualizar seu perfil. - Visualização de: Nome, período, turma, email e cpf.</p>

        <button form="f" name="acao" value="perfil">Acessar</button>
    </div>
</section>

</body>

</html>