<%@ page import="com.hogwarts.model.Boletim" %>
<%@ page import="java.util.List" %>
<%@ page import="com.hogwarts.utils.Formatador" %>
<%@ page import="static com.hogwarts.utils.Formatador.mostrar" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 04/02/2026
  Time: 00:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%--Capturando valores do servlet--%>
<%
    List<Boletim> boletins = (List<Boletim>) request.getAttribute("boletins");
    String disciplina = (String) request.getAttribute("disciplina");
%>

<html>
<head>
    <title>Observação</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/servlet-pages/observacoes.css">
</head>
<body>
<main>
    <%if (boletins != null && !boletins.isEmpty()){%>
    <table border="1">
        <thead>
            <tr>
                <th>Aluno</th>
                <th>Casa</th>
                <th>Observacao</th>
                <th colspan="2">Acoes</th>
            </tr>
        </thead>

        <%int i = 0;
        for (Boletim b : boletins){
            if (b.getDisciplina().getNome().equals(disciplina)){
        String id = String.valueOf(i++);%>
        <tbody>
            <tr>
                <td><%=b.getAluno().getNome()%></td>
                <td><%=b.getDisciplina().getNome()%></td>
                <td>
                    <%if (b.getObservacao().getObservacao() == null){%> <%=Formatador.mostrar(b.getObservacao().getObservacao())%>
                    <%}else{%> <strong><%=b.getObservacao().getObservacao()%></strong> <%}%>
                </td>

                <%if (b.getObservacao().getObservacao() == null){%>

                <td class="modal" colspan="2">
                    <button type="button" name="" class="abre-modal" data-modal="modal-add-<%=id%>">Adicionar</button>

                    <dialog id="modal-add-<%=id%>">
                        <button type="button" class="fecha-modal" data-modal="modal-add-<%=id%>">x</button>
                        <form action="observacoes-servlet" method="get">
                            <label for="adicionar">Digite a observação:</label>
                            <input type="text" name="adicionar" id="adicionar" autocomplete="off" required>

                            <input type="hidden" name="matricula-aluno" value="<%=b.getAluno().getMatricula()%>">
                            <input type="hidden" name="id-disciplina" value="<%=b.getDisciplina().getId()%>">
                            <input type="hidden" name="disciplina" value="<%=disciplina%>">

                            <button type="submit" name="acao" value="adicionar">Enviar dados</button>
                        </form>
                    </dialog>
                </td>

                <%} else {%>
                    <td class="modal">
                        <button type="button" name="" class="abre-modal" data-modal="modal-edita-<%=id%>">Editar</button>

                        <dialog id="modal-edita-<%=id%>">
                            <button type="button" class="fecha-modal" data-modal="modal-edita-<%=id%>">x</button>

                            <p>Antiga observação: <em><%=b.getObservacao().getObservacao()%></em></p>

                            <form action="observacoes-servlet" method="get">
                                <label for="editar">Digite a nova observação:</label>
                                <input type="text" name="editar" id="editar" autocomplete="off" required>

                                <input type="hidden" name="id-observacao" value="<%=b.getObservacao().getId()%>">
                                <input type="hidden" name="disciplina" value="<%=disciplina%>">

                                <button type="submit" name="acao" value="editar">Enviar dados</button>
                            </form>
                        </dialog>
                    </td>

                    <td class="modal">
                        <button type="button" name="" class="abre-modal" data-modal="modal-exclui-<%=id%>">Excluir</button>

                        <dialog id="modal-exclui-<%=id%>">
                            <button type="button" class="fecha-modal" data-modal="modal-exclui-<%=id%>">x</button>
                            <form action="observacoes-servlet" method="get">
                                <label for="excluir">Você tem certeza que quer excluir essa observação?</label>

                                <input type="hidden" name="nome-aluno" value="<%=b.getAluno().getNome()%>">
                                <input type="hidden" name="nome-disciplina" value="<%=b.getDisciplina().getNome()%>">
                                <input type="hidden" name="disciplina" value="<%=disciplina%>">

                                <button type="submit" name="acao" value="excluir">Sim</button>
                                <button type="button" class="fecha-modal" data-modal="modal-exclui-<%=id%>">Não</button>
                            </form>
                        </dialog>
                    </td>
                <%}%>
            </tr>
            <%}}%>
        </tbody>
    </table>
    <%} else {%> <p>Nenhum aluno encontrado.</p> <%}%>
</main>
<script src="<%=request.getContextPath()%>/assets/js/script.js"></script>
</body>
</html>
