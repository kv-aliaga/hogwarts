<%@ page import="com.hogwarts.model.Boletim" %>
<%@ page import="java.util.List" %>
<%@ page import="static com.hogwarts.utils.Formatador.mostrar" %>
<%@ page import="java.util.Random" %><%--
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
    <title>Boletim - <%=disciplina%></title>

    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/boletim.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
</head>
<body>
<main>

    <%if (boletins != null && !boletins.isEmpty()){%>
    <div class="table-wrapper"> <%-- div p/ auxiliar na rolagem apenas da tabela --%>
        <table border="1">
            <thead>
            <tr>
                <th>Aluno</th>
                <th>Casa</th>
                <th>Professor</th>
                <th>Matéria</th>
                <th>Nota 1</th>
                <th>Nota 2</th>
                <th>Média</th>
                <th>Observação</th>
                <th>Situação</th>
                <th colspan="3">Ações</th>
            </tr>
            </thead>

            <tbody>
            <%int i = 0;
                for (Boletim b : boletins){
                    if (b.getDisciplina().getNome().equals(disciplina)) {
                        String id = String.valueOf(i++);%>
            <tr>
                <td><%=b.getAluno().getNome()%></td>
                <td><%=b.getCasaHogwarts().getNome()%></td>
                <td><%=b.getProfessor().getNome()%></td>
                <td><%=b.getDisciplina().getNome()%></td>
                <td><%=b.getNota1() == 0 ? "--" : ("<strong>" + b.getNota1() + "</strong>") %></td>
                <td><%=b.getNota2() == 0 ? "--" : ("<strong>" + b.getNota2() + "</strong>") %></td>
                <td><%=b.getMedia() == 0 ? "--" : ("<strong>" + b.getMedia() + "</strong>")%></td>
                <td><%=mostrar(b.getObservacao().getObservacao())%></td>
                <td><%=b.getSituacao().getNome()%></td>

                <%if (b.getNota1() == 0) {%>
                <td colspan="3" class="modal">
                    <button type="button" name="" class="abre-modal" data-modal="modal-add-semnotas-<%=id%>">Adicionar</button>

                    <dialog id="modal-add-semnotas-<%=id%>">
                        <button type="button" class="fecha-modal" data-modal="modal-add-semnotas-<%=id%>">x</button>
                        <form action="nota-servlet" method="post">
                            <label for="nota1-semnotas">Digite a nota:</label>
                            <input type="number" name="nota" id="nota1-semnotas" step="0.01" min="0.01" max="10" required>

                            <input type="hidden" name="matricula-aluno" value="<%=b.getAluno().getMatricula()%>">
                            <input type="hidden" name="id-disciplina" value="<%=b.getDisciplina().getId()%>">
                            <input type="hidden" name="eh-n1" value="true">
                            <input type="hidden" name="tipo" value="todos">
                            <input type="hidden" name="disciplina" value="<%=disciplina%>">

                            <button type="submit" name="acao" value="inserir">Enviar dados</button>
                        </form>
                    </dialog>
                </td>

                <%} else if (b.getNota2() == 0) {%>
                <td class="modal">
                    <button type="button" name="" class="abre-modal" data-modal="modal-add-umanota-<%=id%>">Adicionar</button>

                    <dialog id="modal-add-umanota-<%=id%>">
                        <button type="button" class="fecha-modal" data-modal="modal-add-umanota-<%=id%>">x</button>
                        <form action="nota-servlet" method="post">
                            <label for="nota2-semnotas">Digite a nota:</label>
                            <input type="number" name="nota" id="nota2-semnotas" step="0.01" min="0.01" max="10" required>

                            <input type="hidden" name="matricula-aluno" value="<%=b.getAluno().getMatricula()%>">
                            <input type="hidden" name="id-disciplina" value="<%=b.getDisciplina().getId()%>">
                            <input type="hidden" name="eh-n1" value="false">
                            <input type="hidden" name="tipo" value="todos">
                            <input type="hidden" name="disciplina" value="<%=disciplina%>">

                            <button type="submit" name="acao" value="inserir">Enviar dados</button>
                        </form>
                    </dialog>
                </td>

                <td class="modal">
                    <button type="button" name="" class="abre-modal" data-modal="modal-edita-umanota-<%=id%>">Editar</button>

                    <dialog id="modal-edita-umanota-<%=id%>">
                        <button type="button" class="fecha-modal" data-modal="modal-edita-umanota-<%=id%>">x</button>

                        <p>Antiga nota: <em><%=b.getNota1()%></em></p>

                        <form action="nota-servlet" method="post">
                            <label for="nota-edita">Digite a nova nota:</label>
                            <input type="number" name="nota-edita" id="nota-umanota" step="0.01" min="0.01" max="10" required>

                            <input type="hidden" name="matricula-aluno" value="<%=b.getAluno().getMatricula()%>">
                            <input type="hidden" name="id-disciplina" value="<%=b.getDisciplina().getId()%>">
                            <input type="hidden" name="eh-n1" value="true">
                            <input type="hidden" name="tipo" value="todos">
                            <input type="hidden" name="disciplina" value="<%=disciplina%>">

                            <button type="submit" name="acao" value="atualizar">Enviar dados</button>
                        </form>
                    </dialog>
                </td>

                <td class="modal">
                    <button type="button" name="" class="abre-modal" data-modal="modal-exclui-umanota-<%=id%>">Excluir</button>

                    <dialog id="modal-exclui-umanota-<%=id%>">
                        <button type="button" class="fecha-modal" data-modal="modal-exclui-umanota-<%=id%>">x</button>
                        <form action="nota-servlet" method="post">
                            <p>Nota a ser excluída: <em><%=b.getNota1()%></em></p>
                            <label for="excluir">Você tem certeza que quer excluir essa nota?</label>

                            <input type="hidden" name="matricula-aluno" value="<%=b.getAluno().getMatricula()%>">
                            <input type="hidden" name="id-disciplina" value="<%=b.getDisciplina().getId()%>">
                            <input type="hidden" name="eh-n1" value="true">
                            <input type="hidden" name="tipo" value="todos">
                            <input type="hidden" name="disciplina" value="<%=disciplina%>">

                            <button type="submit" name="acao" value="excluir">Sim</button>
                            <button type="button" class="fecha-modal" data-modal="modal-exclui-umanota-<%=id%>">Não</button>
                        </form>
                    </dialog>
                </td>

                <%} else {%>
                <td class="modal" colspan="2">
                    <button type="button" name="" class="abre-modal" data-modal="modal-edita-duasnotas-<%=id%>">Editar</button>

                    <dialog id="modal-edita-duasnotas-<%=id%>">
                        <button type="button" class="fecha-modal" data-modal="modal-edita-duasnotas-<%=id%>">x</button>

                        <p>Antiga nota: <em class="antiga-nota"></em></p>

                        <form action="nota-servlet" method="post">
                            <label for="nota">Selecione uma nota para editar:</label>
                            <select name="nota" class="nota-select" required>
                                <option value="">Selecione</option>
                                <option value="<%=b.getNota1()%>" data-n1="true">Nota 1</option>
                                <option value="<%=b.getNota2()%>" data-n1="false">Nota 2</option>
                            </select>

                            <label for="nota-edita">Digite a nova nota:</label>
                            <input type="number" name="nota-edita" id="nota-edita" step="0.01" min="0.01" max="10" required>

                            <input type="hidden" name="matricula-aluno" value="<%=b.getAluno().getMatricula()%>">
                            <input type="hidden" name="id-disciplina" value="<%=b.getDisciplina().getId()%>">
                            <input type="hidden" name="eh-n1" class="eh-n1">
                            <input type="hidden" name="tipo" value="todos">
                            <input type="hidden" name="disciplina" value="<%=disciplina%>">

                            <button type="submit" name="acao" value="atualizar">Enviar dados</button>
                        </form>
                    </dialog>
                </td>

                <td class="modal">
                    <button type="button" name="" class="abre-modal" data-modal="modal-exclui-duasnotas-<%=id%>">Excluir</button>

                    <dialog id="modal-exclui-duasnotas-<%=id%>">
                        <button type="button" class="fecha-modal" data-modal="modal-exclui-duasnotas-<%=id%>">x</button>

                        <p>Nota a ser excluída: <em class="antiga-nota"></em></p>

                        <form action="nota-servlet" method="post">
                            <label for="nota">Selecione uma nota para excluir:</label>
                            <select name="nota" class="nota-select" required>
                                <option value="">Selecione</option>
                                <option value="<%=b.getNota1()%>" data-n1="true">Nota 1</option>
                                <option value="<%=b.getNota2()%>" data-n1="false">Nota 2</option>
                            </select>

                            <input type="hidden" name="matricula-aluno" value="<%=b.getAluno().getMatricula()%>">
                            <input type="hidden" name="id-disciplina" value="<%=b.getDisciplina().getId()%>">
                            <input type="hidden" name="eh-n1" class="eh-n1">
                            <input type="hidden" name="tipo" value="todos">
                            <input type="hidden" name="disciplina" value="<%=disciplina%>">

                            <label for="excluir">Você tem certeza que quer excluir essa nota?</label>

                            <button type="submit" name="acao" value="excluir">Sim</button>
                            <button type="button" class="fecha-modal" data-modal="modal-exclui-duasnotas-<%=id%>">Não</button>
                        </form>
                    </dialog>
                </td>
            </tr>
            <%}}}%>
            </tbody>

        </table>
    </div>
    <%} else {%> <p>Nenhum boletim encontrado.</p> <%}%>
</main>

<script src="<%=request.getContextPath()%>/assets/js/script.js"></script>
</body>
</html>