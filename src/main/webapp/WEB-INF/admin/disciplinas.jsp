<%@ page import="com.hogwarts.model.banco.Disciplina" %>
<%@ page import="com.hogwarts.utils.Formatador" %>
<%@ page import="java.text.Normalizer" %>
<%@ page import="java.util.*" %><%--
  Created by IntelliJ IDEA.
  User: daviramos-ieg
  Date: 07/02/2026
  Time: 19:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Disciplina> disciplinas = (List<Disciplina>) request.getAttribute("disciplinas");
    HashMap<Integer, String> profJaMostrados = new HashMap<>();
%>

<html>
<head>
    <title>Disciplinas</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/modal.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/disciplinas.css">
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/assets/icons/favicon.ico" type="image/x-icon">
</head>
<body>
<main>
    <%if (disciplinas != null && !disciplinas.isEmpty()){%>
    <table border="1">
        <thead>
        <tr>
            <th>Matéria</th>
            <th>Professor</th>
            <th colspan="2">Ações</th>
        </tr>
        </thead>

        <%int i = 0;
            for (Disciplina d : disciplinas){
                String id = String.valueOf(i++);%>
        <tbody>
        <tr>
            <td><%=Formatador.mostrar(d.getNome())%></td>
            <td><%=Formatador.mostrar(d.getProfessor().getNome())%></td>
            <%
                String professorAtual = d.getProfessor().getNome();
                if (d.getNome() != null){%>
            <td class="modal">
                <button type="button" class="abre-modal" data-modal="modal-edita-<%=id%>">Editar matéria</button>

                <dialog id="modal-edita-<%=id%>">
                    <button class="fecha-modal" data-modal="modal-edita-<%=id%>">x</button>

                    <p>
                        Disciplina: <em><%=Formatador.mostrar(d.getNome())%></em><br>
                        Antigo professor: <em><%=Formatador.mostrar(professorAtual)%></em>
                    </p>

                    <form method="post" action="disciplina-servlet">
                        <label for="id-prof">Selecione o novo professor:</label>
                        <select name="id-prof" id="id-prof" required>
                            <option value="">Selecione</option>
                            <%for (Disciplina di : disciplinas) {
                                String nome = (di.getProfessor() != null) ? di.getProfessor().getNome() : null;
                                Integer idProf = (di.getProfessor() != null) ? di.getProfessor().getId() : null;

                                if (idProf != null && nome != null && !Objects.equals(nome, professorAtual)){
                            %>
                            <option value="<%=di.getProfessor().getId()%>"><%=di.getProfessor().getNome()%></option>
                            <%}}%>
                        </select>

                        <input type="hidden" name="id-disc" value="<%=d.getId()%>">

                        <button type="submit" name="acao" value="atualizarDisc">Enviar dados</button>
                    </form>
                </dialog>
            </td>
            <%}%>

            <%if (d.getProfessor().getNome() != null){%>
            <td class="modal">
                <button type="button" class="abre-modal" data-modal="modal-exclui-<%=id%>">Excluir professor</button>

                <dialog id="modal-exclui-<%=id%>">
                    <button class="fecha-modal" data-modal="modal-exclui-<%=id%>">x</button>

                    <p>
                        Disciplina: <em><%=Formatador.mostrar(d.getNome())%></em><br>
                        Professor atual: <em><%=professorAtual%></em>

                        <strong>Atenção! Essa ação é irreversível. Você talvez precise realocar um novo professor para esta matéria.</strong>
                        <strong>Caso o professor seja gestor de uma casa será preciso realocá-lo também.</strong>
                        <strong>Todas as observações deste professor serão excluídas.</strong>
                    </p>

                    <form action="disciplina-servlet" method="post">
                        <label for="acao">Você tem certeza que quer excluir esse professor?</label>

                        <input type="hidden" name="idProf" value="<%=d.getProfessor().getId()%>">

                        <button type="submit" name="acao" value="excluirProf">Sim</button>
                        <button type="button" class="fecha-modal" data-modal="modal-exclui-<%=id%>">Não</button>
                    </form>
                </dialog>
            </td>
            <%}%>
        </tr>
        </tbody>
        <%}%>
    </table>

    <div class="modal">
        <button type="button" class="abre-modal" data-modal="modal-add-disc">Adicionar Disciplina</button>

        <dialog id="modal-add-disc">
            <button class="fecha-modal" data-modal="modal-add-disc">x</button>

            <form method="post" action="disciplina-servlet">
                <label for="disciplina">Digite o nome da disciplina:</label>
                <input type="text" name="disciplina" id="disciplina" maxlength="50">

                <label for="professor">Selecione o novo professor:</label>
                <select name="professor" id="professor" required>
                    <option value="">Selecione</option>
                    <%
                        for (Disciplina di : disciplinas){
                            if (di.getProfessor().getNome() != null){
                                int id = di.getProfessor().getId();
                                String nome = di.getProfessor().getNome();

                                if (!profJaMostrados.containsKey(id)) profJaMostrados.put(id, nome);
                            }
                        }

                        for (Map.Entry<Integer, String> p : profJaMostrados.entrySet()){%>
                    <option value="<%=p.getKey()%>"><%=p.getValue()%></option>
                    <%} %>
                </select>

                <button type="submit" name="acao" value="inserirDisc">Enviar dados</button>
            </form>
        </dialog>
    </div>

    <div class="modal">
        <button type="button" class="abre-modal" data-modal="modal-add-prof">Adicionar Professor</button>

        <dialog id="modal-add-prof">
            <button class="fecha-modal" data-modal="modal-add-prof">x</button>

            <form method="post" action="disciplina-servlet">
                <label for="professor">Digite o nome do professor:</label>
                <input type="text" name="professor" id="professor" maxlength="70" required>

                <label for="usuario">Digite o nome do usuário:</label>
                <input type="text" name="usuario" id="usuario" maxlength="50" pattern="^[a-z]+\.[a-z]+$" required>

                <label for="senha">Digite a senha:</label>
                <input type="password" name="senha" id="senha" required>

                <button type="submit" name="acao" value="inserirProf">Enviar dados</button>
            </form>
        </dialog>
    </div>


    <%} else {%> <p>Nenhuma disciplina encontrada.</p> <%}%>
</main>

<script src="<%=request.getContextPath()%>/assets/js/script.js"></script>

</body>
</html>