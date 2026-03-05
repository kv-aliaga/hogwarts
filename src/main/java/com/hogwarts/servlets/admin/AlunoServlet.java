package com.hogwarts.servlets.admin;

import com.hogwarts.dao.AlunoDAO;
import com.hogwarts.exceptions.RegexMatchException;
import com.hogwarts.model.banco.Aluno;
import com.hogwarts.model.banco.CasaHogwarts;
import com.hogwarts.utils.Regex;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

@WebServlet(name = "AlunoServlet", value = "/aluno-servlet")
public class AlunoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try{
            switch(req.getParameter("acao")){
                case "inserir":
                    inserirAluno(req);
                    resp.sendRedirect(req.getContextPath() + "/admin-servlet?tipo=alunos");
                    break;

                case "atualizar":
                    atualizarAluno(req);
                    resp.sendRedirect(req.getContextPath() + "/admin-servlet?tipo=alunos");
                    break;

                case "excluir":
                    excluirAluno(req);
                    resp.sendRedirect(req.getContextPath() + "/admin-servlet?tipo=alunos");
                    break;

                case "boletim":
                    boletim(req);
                    req.getRequestDispatcher("WEB-INF/aluno/boletim.jsp").forward(req, resp);
                    break;

                case "perfil":
                    boletim(req);
                    req.getRequestDispatcher("WEB-INF/aluno/perfil.jsp").forward(req, resp);
                    break;

                default:
                    req.setAttribute("mensagemErro", "Não foi possível concluir sua solicitação.");
                    req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
            }
        } catch (SQLException sqle){
            sqle.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um problema com o banco de dados, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (ClassNotFoundException cnfe){
            cnfe.printStackTrace();
            req.setAttribute("mensagemErro", "O sistema não conseguiu acessar um componente necessário, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp");
        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            req.setAttribute("mensagemErro", "Selecione uma opção válida.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }catch (NoSuchAlgorithmException nsae) {
            nsae.printStackTrace();
            req.setAttribute("mensagemErro", "Houve um erro ao processar as informações de criptografia de senha, não se preocupe, tente novamente em alguns minutos.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (RegexMatchException rme){
            req.setAttribute("mensagemErro", rme.getMessage());
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        } catch (NullPointerException npe){
            npe.printStackTrace();
            req.setAttribute("mensagemErro", "Sua sessão expirou, reenvie o formulário.");
            req.getRequestDispatcher("WEB-INF/pagina-erro.jsp").forward(req, resp);
        }
    }

    private void inserirAluno(HttpServletRequest req) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException{
        CasaHogwarts c = new CasaHogwarts();
        c.setId(Integer.parseInt(req.getParameter("casa")));

        String nome = req.getParameter("aluno");
        String cpf = Regex.formatarCpf(req.getParameter("cpf"));
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        if (!Regex.checarCpf(cpf)) throw new RegexMatchException("Digite um CPF válido.");
        if (!Regex.checarEmail(email)) throw new RegexMatchException("O email digitado é inválido e não segue os padrões da escola.");

        new AlunoDAO().inserirAluno(new Aluno(nome, cpf, email, senha, c));
    }

    private void atualizarAluno(HttpServletRequest req) throws SQLException, ClassNotFoundException{
        Aluno a = new Aluno();

        String email = req.getParameter("email");

        a.setEmail(email);
        a.setMatricula(Integer.parseInt(req.getParameter("matricula")));

        if (!Regex.checarEmail(email)) throw new RegexMatchException("O email digitado é inválido e não segue os padrões da escola.");

        new AlunoDAO().atualizarAluno(a);
    }

    private void excluirAluno(HttpServletRequest req) throws SQLException, ClassNotFoundException{
        new AlunoDAO().excluirAluno(Integer.parseInt(req.getParameter("matricula")));
    }

    private void boletim(HttpServletRequest req) throws SQLException, ClassNotFoundException {
        int matricula = Integer.parseInt(req.getParameter("matricula"));

        req.setAttribute("boletins", new AlunoDAO().gerarBoletimIndividual(matricula));
        req.setAttribute("aluno", new AlunoDAO().buscarAluno(matricula));
    }

    private void perfil(HttpServletRequest req) throws SQLException, ClassNotFoundException {
        int matricula = Integer.parseInt(req.getParameter("matricula"));
        req.setAttribute("aluno", new AlunoDAO().buscarAluno(matricula));
    }
}

