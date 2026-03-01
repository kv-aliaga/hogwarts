<%@ page import="com.hogwarts.model.Boletim" %>
<%@ page import="com.hogwarts.utils.Formatador" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%--Capturando valores do servlet--%>
<%
    Boletim boletim = (Boletim) request.getAttribute("boletim");
    String disciplina = (String) request.getAttribute("disciplina");
%>

<html>
<head>
    <title>Boletim Individual - <%=boletim.getAluno().getNome()%></title>


    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/boletim-individual.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">

</head>
<body>
<main>
    <h1><%=boletim.getAluno().getNome()%></h1>
    <h2><%=boletim.getCasaHogwarts().getNome()%></h2>
    <p><%=disciplina%></p>

    <%String id = String.valueOf(1);
        if (boletim.getDisciplina().getNome().equals(disciplina)){%>
    <strong>Professor: <span><%=boletim.getProfessor().getNome()%></span></strong> <br>
    <strong>Disciplina: <span><%=boletim.getDisciplina().getNome()%></span></strong> <br>
    <strong>Nota 1: <span><%=boletim.getNota1() == 0 ? "--" : ("<strong>" + boletim.getNota1() + "</strong>") %></span></strong> <br>
    <strong>Nota 2: <span><%=boletim.getNota2() == 0 ? "--" : ("<strong>" + boletim.getNota2() + "</strong>") %></span></strong> <br>
    <strong>Média: <span><%=boletim.getMedia() == 0 ? "--" : ("<strong>" + boletim.getMedia() + "</strong>")%></span></strong> <br>
    <strong>Observação: <span><%=Formatador.mostrar(boletim.getObservacao().getObservacao())%></span></strong> <br>
    <strong>Situação: <span class="situacao-final"><%=boletim.getSituacao().getNome()%></span></strong> <br> <br>
    <%}%>

    <section>
        <h3>NOTAS</h3>

        <%if (boletim.getNota1() == 0) {%>
        <div class="modal-container"> <%-- div p/ agrupar botões --%>
            <button type="button" name="" class="abre-modal" data-modal="modal-add-semnotas-<%=id%>">Adicionar Nota</button>

            <dialog id="modal-add-semnotas-<%=id%>">
                <button type="button" class="fecha-modal" data-modal="modal-add-semnotas-<%=id%>">x</button>
                <form action="nota-servlet" method="post">
                    <label for="nota1-semnotas">Digite a nota:</label>
                    <input type="number" name="nota" id="nota1-semnotas" step="0.01" min="0.01" max="10" required>

                    <input type="hidden" name="matricula-aluno" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="id-disciplina" value="<%=boletim.getDisciplina().getId()%>">
                    <input type="hidden" name="eh-n1" value="true">
                    <input type="hidden" name="tipo" value="individual">
                    <input type="hidden" name="matricula" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="disciplina" value="<%=disciplina%>">

                    <button type="submit" name="acao" value="inserir">Enviar dados</button>
                </form>
            </dialog>
        </div>

        <%} else if (boletim.getNota2() == 0) {%>
        <div class="modal-container"> <%-- div p/ grupar botões --%>
            <button type="button" name="" class="abre-modal" data-modal="modal-add-umanota-<%=id%>">Adicionar Nota</button>

            <dialog id="modal-add-umanota-<%=id%>">
                <button type="button" class="fecha-modal" data-modal="modal-add-umanota-<%=id%>">x</button>
                <form action="nota-servlet" method="post">
                    <label for="nota2-semnotas">Digite a nota:</label>
                    <input type="number" name="nota" id="nota2-semnotas" step="0.01" min="0.01" max="10" required>

                    <input type="hidden" name="matricula-aluno" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="id-disciplina" value="<%=boletim.getDisciplina().getId()%>">
                    <input type="hidden" name="eh-n1" value="false">
                    <input type="hidden" name="tipo" value="individual">
                    <input type="hidden" name="matricula" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="disciplina" value="<%=disciplina%>">

                    <button type="submit" name="acao" value="inserir">Enviar dados</button>
                </form>
            </dialog>
        </div>

        <div class="modal-container">
            <button type="button" name="" class="abre-modal" data-modal="modal-edita-umanota-<%=id%>">Editar Nota</button>

            <dialog id="modal-edita-umanota-<%=id%>">
                <button type="button" class="fecha-modal" data-modal="modal-edita-umanota-<%=id%>">x</button>

                <p>Antiga nota: <em><%=boletim.getNota1()%></em></p>

                <form action="nota-servlet" method="post">
                    <label for="nota-edita">Digite a nova nota:</label>
                    <input type="number" name="nota-edita" id="nota-umanota" step="0.01" min="0.01" max="10" required>

                    <input type="hidden" name="matricula-aluno" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="id-disciplina" value="<%=boletim.getDisciplina().getId()%>">
                    <input type="hidden" name="eh-n1" value="true">
                    <input type="hidden" name="tipo" value="individual">
                    <input type="hidden" name="matricula" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="disciplina" value="<%=disciplina%>">

                    <button type="submit" name="acao" value="atualizar">Enviar dados</button>
                </form>
            </dialog>
        </div>

        <div class="modal-container">
            <button type="button" name="" class="abre-modal" data-modal="modal-exclui-umanota-<%=id%>">Excluir Nota</button>

            <dialog id="modal-exclui-umanota-<%=id%>">
                <button type="button" class="fecha-modal" data-modal="modal-exclui-umanota-<%=id%>">x</button>
                <form action="nota-servlet" method="post">
                    <p>Nota a ser excluída: <em><%=boletim.getNota1()%></em></p>
                    <label for="excluir">Você tem certeza que quer excluir essa nota?</label>

                    <input type="hidden" name="matricula-aluno" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="id-disciplina" value="<%=boletim.getDisciplina().getId()%>">
                    <input type="hidden" name="eh-n1" value="true">
                    <input type="hidden" name="tipo" value="individual">
                    <input type="hidden" name="matricula" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="disciplina" value="<%=disciplina%>">

                    <button type="submit" name="acao" value="excluir">Sim</button>
                    <button type="button" class="fecha-modal" data-modal="modal-exclui-umanota-<%=id%>">Não</button>
                </form>
            </dialog>
        </div>

        <%} else {%>
        <div class="modal-container">
            <button type="button" name="" class="abre-modal" data-modal="modal-edita-duasnotas-<%=id%>">Editar Nota</button>

            <dialog id="modal-edita-duasnotas-<%=id%>">
                <button type="button" class="fecha-modal" data-modal="modal-edita-duasnotas-<%=id%>">x</button>

                <p>Antiga nota: <em class="antiga-nota"></em></p>

                <form action="nota-servlet" method="post">
                    <label for="nota">Selecione uma nota para editar:</label>
                    <select name="nota" class="nota-select" required>
                        <option value="">Selecione</option>
                        <option value="<%=boletim.getNota1()%>" data-n1="true">Nota 1</option>
                        <option value="<%=boletim.getNota2()%>" data-n1="false">Nota 2</option>
                    </select>

                    <label for="nota-edita">Digite a nova nota:</label>
                    <input type="number" name="nota-edita" id="nota-edita" step="0.01" min="0.01" max="10" required>

                    <input type="hidden" name="matricula-aluno" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="id-disciplina" value="<%=boletim.getDisciplina().getId()%>">
                    <input type="hidden" name="eh-n1" class="eh-n1">
                    <input type="hidden" name="tipo" value="individual">
                    <input type="hidden" name="matricula" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="disciplina" value="<%=disciplina%>">

                    <button type="submit" name="acao" value="atualizar">Enviar dados</button>
                </form>
            </dialog>
        </div>

        <div class="modal-container">
            <button type="button" name="" class="abre-modal" data-modal="modal-exclui-duasnotas-<%=id%>">Excluir Nota</button>

            <dialog id="modal-exclui-duasnotas-<%=id%>">
                <button type="button" class="fecha-modal" data-modal="modal-exclui-duasnotas-<%=id%>">x</button>

                <p>Nota a ser excluída: <em class="antiga-nota"></em></p>

                <form action="nota-servlet" method="post">
                    <label for="nota">Selecione uma nota para excluir:</label>
                    <select name="nota" class="nota-select" required>
                        <option value="">Selecione</option>
                        <option value="<%=boletim.getNota1()%>" data-n1="true">Nota 1</option>
                        <option value="<%=boletim.getNota2()%>" data-n1="false">Nota 2</option>
                    </select>

                    <input type="hidden" name="matricula-aluno" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="id-disciplina" value="<%=boletim.getDisciplina().getId()%>">
                    <input type="hidden" name="eh-n1" class="eh-n1">
                    <input type="hidden" name="tipo" value="individual">
                    <input type="hidden" name="matricula" value="<%=boletim.getAluno().getMatricula()%>">
                    <input type="hidden" name="disciplina" value="<%=disciplina%>">

                    <label for="excluir">Você tem certeza que quer excluir essa nota?</label>

                    <button type="submit" name="acao" value="excluir">Sim</button>
                    <button type="button" class="fecha-modal" data-modal="modal-exclui-duasnotas-<%=id%>">Não</button>
                </form>
            </dialog>
        </div>
        <%}%>
    </section>

</main>

<script src="<%=request.getContextPath()%>/assets/js/script.js"></script>
</body>
</html>