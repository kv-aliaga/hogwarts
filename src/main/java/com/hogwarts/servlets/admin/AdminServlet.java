package com.hogwarts.servlets.admin;

import com.hogwarts.dao.admin.CasaDAO;
import com.hogwarts.dao.admin.AdminDAO;
import com.hogwarts.dao.admin.DisciplinaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

@WebServlet(name = "AdminServlet", value = "/admin-servlet")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AdminDAO d = new AdminDAO();
        try {
            String email = req.getParameter("email-admin");
            String senha = req.getParameter("senha-admin");
            String nome = d.ehAdmin(email, senha);

            if (nome != null){
                HttpSession sessaoNome = req.getSession();
                sessaoNome.setAttribute("nomeAdmin", nome);
                req.getRequestDispatcher("WEB-INF/admin/inicial.jsp").forward(req, resp);
            } else {
                req.setAttribute("mensagemErro", "Houve um problema com o seu cadastro. Esta página é somente para o diretor.");
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
        } catch (NoSuchAlgorithmException nsae) {
            nsae.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um erro ao processar as informações de criptografia de senha, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }catch (NullPointerException npe){
            npe.printStackTrace();
            req.setAttribute("mensagemErro", "Sua sessão expirou, reenvie o formulário.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        switch (req.getParameter("tipo")){
            case "casas":
                casas(req, resp); break;

            case "disciplinas":
                disciplinas(req, resp); break;

            case "alunos":
                alunos(req, resp); break;

            default:
                req.setAttribute("mensagemErro", "Não foi possível concluir sua solicitação.");
                req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }

    private void casas(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        try{
            req.setAttribute("casasHogwarts", new CasaDAO().buscarCasaHogwarts());
            req.setAttribute("professores", new DisciplinaDAO().buscarProfessores());

            req.getRequestDispatcher("WEB-INF/admin/casas.jsp").forward(req, resp);
        } catch (SQLException sqle){
            sqle.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um problema com o banco de dados, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            req.setAttribute("mensagemErro", "O sistema não conseguiu acessar um componente necessário, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }

    private void disciplinas(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        try{
            req.setAttribute("disciplinas", new DisciplinaDAO().buscarProfessores());
            req.getRequestDispatcher("WEB-INF/admin/disciplinas.jsp").forward(req, resp);
        } catch (SQLException sqle){
            sqle.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um problema com o banco de dados, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            req.setAttribute("mensagemErro", "O sistema não conseguiu acessar um componente necessário, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }


    private void alunos(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        try{
            req.setAttribute("alunos", new com.hogwarts.dao.AlunoDAO().buscarAlunos());
            req.setAttribute("casasHogwarts", new CasaDAO().buscarCasaHogwarts());

            req.getRequestDispatcher("WEB-INF/admin/alunos.jsp").forward(req, resp);
        } catch (SQLException sqle){
            sqle.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um problema com o banco de dados, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            req.setAttribute("mensagemErro", "O sistema não conseguiu acessar um componente necessário, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }
}