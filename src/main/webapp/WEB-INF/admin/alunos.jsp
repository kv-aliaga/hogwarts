<%@ page import="com.hogwarts.model.Boletim" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hogwarts.model.banco.CasaHogwarts" %>
<%@ page import="com.hogwarts.model.banco.Aluno" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 04/02/2026
  Time: 00:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--Capturando valores do servlet--%>
<%
    List<Aluno> alunos = (List<Aluno>) request.getAttribute("alunos");
    List<CasaHogwarts> casasHogwarts = (List<CasaHogwarts>) request.getAttribute("casasHogwarts");
%>

<html>
<head>
    <title>Alunos</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/aluno.css">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
</head>
<body>
<main>
    <%if (alunos != null && !alunos.isEmpty()) {%>
    <table border="1">
        <thead>
        <tr>
            <th>Aluno</th>
            <th>Casa</th>
            <th>CPF</th>
            <th>Email</th>
            <th colspan="2">Ações</th>
        </tr>
        </thead>

        <%
            int i = 0;
            for (Aluno a : alunos) {
                String id = String.valueOf(i++);
        %>
        <tbody>
        <tr>
            <td><%=a.getNome()%>
            </td>
            <td><%=a.getCasaHogwarts().getNome()%>
            </td>
            <td><%=a.getCpf()%>
            </td>
            <td><%=a.getEmail()%>
            </td>

            <td class="modal">
                <button type="button" class="abre-modal" data-modal="modal-edita-<%=id%>">Editar</button>

                <dialog id="modal-edita-<%=id%>">
                    <button class="fecha-modal" data-modal="modal-edita-<%=id%>">x</button>

                    <p>
                        Aluno: <em><%=a.getNome()%>
                    </em><br>
                        Email atual: <em><%=a.getEmail()%>
                    </em>
                    </p>

                    <form method="post" action="aluno-servlet">
                        <label for="email">Digite o novo email</label>
                        <input type="email" name="email" id="email" maxlength="50"
                               pattern="^[a-z]+\.[a-z]+@hogwarts\.com$" required>

                        <input type="hidden" name="matricula" value="<%=a.getMatricula()%>">

                        <button type="submit" name="acao" value="atualizar">Enviar dados</button>
                    </form>
                </dialog>
            </td>

            <td class="modal">
                <button type="button" class="abre-modal" data-modal="modal-exclui-<%=id%>">Excluir</button>

                <dialog id="modal-exclui-<%=id%>">
                    <button class="fecha-modal" data-modal="modal-exclui-<%=id%>">x</button>

                    <p>
                        Aluno: <em><%=a.getNome()%>
                    </em><br>

                        <strong>Atenção! Essa ação é irreversível.</strong>
                        <strong>Todas as notas e observações deste aluno serão excluídas.</strong>
                    </p>

                    <form action="aluno-servlet" method="post">
                        <label for="excluir">Você tem certeza que quer excluir esse aluno?</label>

                        <input type="hidden" name="matricula" value="<%=a.getMatricula()%>">

                        <button type="submit" name="acao" value="excluir">Sim</button>
                        <button type="button" class="fecha-modal" data-modal="modal-exclui-<%=id%>">Não</button>
                    </form>
                </dialog>
            </td>
        </tr>
        <%}%>
        </tbody>
    </table>
    <div class="modal">
        <button type="button" class="abre-modal" data-modal="modal-add-disc">Adicionar Aluno</button>

        <dialog id="modal-add-disc">
            <button class="fecha-modal" data-modal="modal-add-disc">x</button>

            <form method="post" action="aluno-servlet" autocomplete="off">
                <label for="aluno">Digite o nome do aluno:</label>
                <input type="text" name="aluno" id="aluno" maxlength="70">

                <label for="cpf">Digite o CPF do aluno:</label>
                <input type="text" name="cpf" id="cpf" maxlength="14" oninput="mascaraCpf(this)"
                       pattern="^\d{3}\.\d{3}\.\d{3}-\d{2}$">

                <label for="email">Digite o email do aluno:</label>
                <input type="email" name="email" id="email" maxlength="50" pattern="^[a-z]+\.[a-z]+@hogwarts\.com$"
                       required>

                <label for="senha">Digite a senha do aluno:</label>
                <input type="password" name="senha" id="senha">

                <label for="casa">Selecione uma casa de Hogwarts</label>
                <select name="casa" id="casa">
                    <option value="">Selecione</option>
                    <%for (CasaHogwarts c : casasHogwarts) {%>
                    <option value="<%=c.getId()%>"><%=c.getNome()%>
                    </option>
                    <%}%>
                </select>

                <button type="submit" name="acao" value="inserir">Enviar dados</button>
            </form>
        </dialog>
    </div>
    <%} else {%>
    <p>Nenhum aluno encontrado</p>
    <%}%>
</main>
<script src="<%=request.getContextPath()%>/assets/js/script.js"></script>
<script src="<%=request.getContextPath()%>/assets/js/regex.js"></script>
</body>
</html>