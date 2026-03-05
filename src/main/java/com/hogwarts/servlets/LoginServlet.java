package com.hogwarts.servlets;

import com.hogwarts.dao.AlunoDAO;
import com.hogwarts.dao.admin.AdminDAO;
import com.hogwarts.dao.admin.DisciplinaDAO;
import com.hogwarts.model.banco.Usuario; // <- use este pacote correto

import com.hogwarts.utils.Conexao;
import com.hogwarts.utils.Regex;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

@WebServlet(name = "LoginServlet", value = "/login-servlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try{
//            captura email ou usuário para login de aluno e professor
            String emailUsuario = req.getParameter("email-usuario");
            String senha = req.getParameter("senha");

//            Se o email for de aluno, tenta verificar se existe
            if (Regex.checarEmail(emailUsuario)){
                AlunoDAO dao = new AlunoDAO();

                if (dao.login(emailUsuario, senha)) {
                    HttpSession session = req.getSession();
                    session.setAttribute("aluno", dao.buscarAluno(emailUsuario, senha));

                    req.getRequestDispatcher("WEB-INF/aluno/inicial.jsp").forward(req, resp);
                } else encaminharErro(req, resp);

//                Se o input for de usuário tenta verificar se é professor
            } if (Regex.checarUsuario(emailUsuario)){
                AdminDAO dao = new AdminDAO();

                if (dao.ehProfessor(emailUsuario, senha) != null){
                    HttpSession sessao = req.getSession();
                    String nome = new AdminDAO().ehProfessor(emailUsuario, senha);
                    String disciplina = new AdminDAO().capturarDisciplina(emailUsuario, nome);

                    sessao.setAttribute("nomeProf", nome);
                    sessao.setAttribute("disciplina", disciplina);
                    sessao.setAttribute("alunos", new AlunoDAO().buscarAlunos());
                    sessao.setAttribute("disciplinaList", new DisciplinaDAO().buscarOutrasDisciplinas(disciplina));

                    req.getRequestDispatcher("WEB-INF/prof/inicial.jsp").forward(req, resp);
                } else encaminharErro(req, resp);
            } else encaminharErro(req, resp);

        } catch (SQLException sqle){
            sqle.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um problema com o banco de dados, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            req.setAttribute("mensagemErro", "O sistema não conseguiu acessar um componente necessário, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp");
        } catch (NoSuchAlgorithmException nsae) {
            nsae.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um erro ao processar as informações de criptografia de senha, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }

    private void encaminharErro(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("mensagemErro", "Houve um problema com o seu cadastro. Esta página é somente para os cadastrados no sistema.");
        req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
    }
}