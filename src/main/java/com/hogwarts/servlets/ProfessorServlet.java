package com.hogwarts.servlets;

import com.hogwarts.dao.AlunoDAO;
import com.hogwarts.dao.admin.AdminDAO;
import com.hogwarts.dao.admin.DisciplinaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.jetbrains.annotations.Nullable;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

@WebServlet(name = "ProfessorServlet", value = "/professor-servlet")
public class ProfessorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String disciplina = req.getParameter("disciplina");
            String nome = req.getParameter("nome");

            if (nome != null){
                HttpSession sessao = req.getSession();

                sessao.setAttribute("nomeProf", nome);
                sessao.setAttribute("disciplina", disciplina);
                sessao.setAttribute("alunos", new AlunoDAO().buscarAlunos());
                sessao.setAttribute("disciplinaList", new DisciplinaDAO().buscarOutrasDisciplinas(disciplina));

                req.getRequestDispatcher("WEB-INF/prof/inicial.jsp").forward(req, resp);
            } else {
                req.setAttribute("mensagemErro", "Houve um problema com o seu cadastro. Esta página é somente para os professores.");
                req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
            }
        } catch (SQLException sqle){
            sqle.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um problema com o banco de dados, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            req.setAttribute("mensagemErro", "O sistema não conseguiu acessar um componente necessário, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (NullPointerException npe){
            npe.printStackTrace();
            req.setAttribute("mensagemErro", "Sua sessão expirou, reenvie o formulário.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }
}
